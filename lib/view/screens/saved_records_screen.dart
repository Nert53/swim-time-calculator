import 'dart:async';
import 'package:code/constants.dart';
import 'package:code/data/database_drift.dart';
import 'package:code/main.dart';
import 'package:code/pdf_export.dart';
import 'package:code/view/screens/home_screen.dart';
import 'package:code/view/widgets/database_list_tile.dart';
import 'package:code/view/widgets/export_database_dialog.dart';
import 'package:code/view/widgets/info_database_dialog.dart';
import 'package:flutter/material.dart';

class SavedRecordsScreen extends StatefulWidget {
  const SavedRecordsScreen({super.key});

  @override
  State<SavedRecordsScreen> createState() => _SavedRecordsScreenState();
}

class _SavedRecordsScreenState extends State<SavedRecordsScreen> {
  late List<SwimRecordItem> _records = [];

  bool isLoading = false;
  bool isUndoPressed = false;
  bool isSelectingView = false;
  bool isSelectedAll = false;
  Set<int> selectedSort = {1};
  List<Map<int, bool>> isSelected = [];
  final noteTextController = TextEditingController();

  Future<void> _getAllRecords() async {
    setState(() {
      isLoading = true;
    });

    _records = await database.allRecords;
    isSelected =
        List.generate(_records.length, (index) => {_records[index].id: false});

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    _getAllRecords();
    super.initState();
  }

  void editNoteDialog(SwimRecordItem record) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Edit note'),
              Text(
                'Record from: ${dateFormat.format(record.dateCreated)}',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextField(
                controller: noteTextController..text = record.note,
                maxLines: 3,
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Discard',
                      style:
                          TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                  ),
                  FilledButton(
                    onPressed: () {
                      SwimRecordItem newRecord =
                          record.copyWith(note: noteTextController.text);
                      database.updateRecordById(newRecord, record.id);
                      Navigator.of(context).pop();

                      setState(() {
                        _getAllRecords();
                      });
                    },
                    child: const Text('Save'),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  void deleteRecord(SwimRecordItem record, int recordIndex) {
    setState(() {
      _records.remove(record);
    });

    displayUndoSnackbar(context, record, recordIndex);
    Timer.periodic(const Duration(milliseconds: 3000), (timer) async {
      if (isUndoPressed) {
        timer.cancel();
        isUndoPressed = false;
        return;
      } else {
        database.deleteRecordById(record.id);
        isUndoPressed = false;
        setState(() {
          _getAllRecords();
        });
      }
    });
  }

  void displayUndoSnackbar(
      BuildContext context, SwimRecordItem record, int recordIndex) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Values of ${dateFormat.format(record.dateCreated)} was deleted.'),
        duration: const Duration(milliseconds: 3000),
        behavior: SnackBarBehavior.floating,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        action: SnackBarAction(
          label: 'Undo',
          textColor: Theme.of(context).colorScheme.primary,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          onPressed: () {
            isUndoPressed = true;
            setState(() {
              _records.insert(recordIndex, record);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Values'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  isSelectingView = !isSelectingView;
                  if (!isSelectingView) {
                    isSelected = List.generate(_records.length,
                        (index) => {_records[index].id: false});
                  }
                });
              },
              icon: Icon(
                  isSelectingView
                      ? Icons.check_box_rounded
                      : Icons.check_box_outlined,
                  color: Theme.of(context).colorScheme.onPrimaryContainer),
              tooltip: 'Enable selection mode.'),
          isSelectingView
              ? const SizedBox.shrink()
              : IconButton(
                  onPressed: () async {
                    List<SwimRecordItem> dataToExport =
                        await database.allRecords;

                    if (context.mounted) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return ExportDatabaseDialog(
                              dataToExport: dataToExport);
                        },
                      );
                    }

                    _getAllRecords();
                  },
                  icon: Icon(Icons.adaptive.share,
                      color: Theme.of(context).colorScheme.onPrimaryContainer),
                  tooltip: 'Export all records.',
                ),
          IconButton(
            icon: const Icon(Icons.help_outline),
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            tooltip: 'View information about icons.',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return InfoDatabaseDialog();
                },
              );
            },
          ),
        ],
      ),
      body: Center(
          child: isLoading
              ? const CircularProgressIndicator()
              : _records.isEmpty
                  ? const Text('No values saved yet.',
                      style: TextStyle(fontSize: 20))
                  : buildValueList()),
    );
  }

  Widget buildValueList() {
    return Column(
      children: [
        SizedBox(height: 8),
        !isSelectingView
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Sort by:',
                      style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(width: 8),
                  SegmentedButton(
                    selected: selectedSort,
                    segments: const [
                      ButtonSegment(value: 2, label: Text('Oldest')),
                      ButtonSegment(value: 1, label: Text('Newest')),
                    ],
                    onSelectionChanged: (value) {
                      setState(() {
                        if (value.contains(1)) {
                          _records.sort(
                              (a, b) => b.dateCreated.compareTo(a.dateCreated));
                        } else {
                          _records.sort(
                              (a, b) => a.dateCreated.compareTo(b.dateCreated));
                        }
                        selectedSort = value;
                      });
                    },
                  ),
                ],
              )
            : ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                leading: FilledButton(
                    onPressed: () {
                      List<SwimRecordItem> selectedRecords = [];
                      for (int i = 0; i < isSelected.length; i++) {
                        if (isSelected[i][_records[i].id] == true) {
                          selectedRecords.add(_records[i]);
                        }
                      }

                      if (selectedRecords.isEmpty) {
                        displaySnackBar(context, 'No values selected.');
                        return;
                      }

                      showDialog(
                        context: context,
                        builder: (context) {
                          return ExportDatabaseDialog(
                              dataToExport: selectedRecords);
                        },
                      );
                    },
                    child: Text('Export selected')),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          isSelectedAll = !isSelectedAll;
                          isSelected = List.generate(_records.length,
                              (index) => {_records[index].id: isSelectedAll});
                        });
                      },
                      icon: Icon(
                        isSelectedAll
                            ? Icons.deselect_rounded
                            : Icons.select_all,
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),
        Expanded(
          child: ListView.builder(
            itemCount: _records.length,
            itemBuilder: (context, index) {
              final record = _records[index];
              var recordCheckedIndex =
                  isSelected.indexWhere((map) => map.containsKey(record.id));

              return Row(
                children: [
                  isSelectingView
                      ? Checkbox(
                          value: isSelected[recordCheckedIndex][record.id],
                          onChanged: (value) {
                            setState(() {
                              isSelected[recordCheckedIndex]
                                  [_records[index].id] = value!;
                            });
                          })
                      : const SizedBox(width: 0),
                  Expanded(
                    child: Container(
                        margin: isSelectingView
                            ? const EdgeInsets.only(
                                top: 8, left: 0, right: 8, bottom: 8)
                            : EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0, 2),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                        child: DatabaseListTile(
                          record: record,
                          index: index,
                          editNoteDialog: editNoteDialog,
                          deleteRecord: deleteRecord,
                          simple: !isSelectingView,
                        )),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
