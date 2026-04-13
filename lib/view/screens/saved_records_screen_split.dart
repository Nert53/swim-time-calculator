import 'dart:async';
import 'package:code/constants.dart';
import 'package:code/data/database_drift.dart';
import 'package:code/functions.dart';
import 'package:code/main.dart';
import 'package:code/view/widgets/database_list_tile.dart';
import 'package:code/view/widgets/export_database_dialog.dart';
import 'package:code/view/widgets/info_database_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class SavedRecordsScreenSplit extends StatefulWidget {
  const SavedRecordsScreenSplit({super.key});

  @override
  State<SavedRecordsScreenSplit> createState() =>
      _SavedRecordsScreenSplitState();
}

class _SavedRecordsScreenSplitState extends State<SavedRecordsScreenSplit> {
  late List<SwimRecordItem> _records = [];

  bool isUndoPressed = false;
  bool isSelectingView = false;
  bool isSelectedAll = false;
  int currentlyDeletedRecordsCount = 0;
  final Set<int> _pendingDeletionIds = {};
  Set<int> selectedSort = {1};
  List<Map<int, bool>> isSelected = [];
  final noteTextController = TextEditingController();

  void _syncSelectionWithRecords(List<SwimRecordItem> records) {
    final previousSelection = <int, bool>{};
    for (final map in isSelected) {
      previousSelection.addAll(map);
    }

    isSelected =
        List.generate(records.length, (index) => {records[index].id: false});

    for (int i = 0; i < records.length; i++) {
      final id = records[i].id;
      isSelected[i][id] = previousSelection[id] ?? false;
    }
  }

  List<SwimRecordItem> _sortRecords(List<SwimRecordItem> records) {
    final sortedRecords = List<SwimRecordItem>.from(records);
    if (selectedSort.contains(1)) {
      sortedRecords.sort((a, b) => b.dateCreated.compareTo(a.dateCreated));
    } else {
      sortedRecords.sort((a, b) => a.dateCreated.compareTo(b.dateCreated));
    }
    return sortedRecords;
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
      _pendingDeletionIds.add(record.id);
    });
    currentlyDeletedRecordsCount++;

    displayUndoSnackbar(context, record, recordIndex);
    Timer(const Duration(milliseconds: 3000), () async {
      if (isUndoPressed) {
        isUndoPressed = false;
        currentlyDeletedRecordsCount--;
        return;
      } else {
        await database.deleteRecordById(record.id);
        isUndoPressed = false;
        currentlyDeletedRecordsCount--;
        if (currentlyDeletedRecordsCount == 0) {
          setState(() {
            _pendingDeletionIds.remove(record.id);
          });
        }
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
              _pendingDeletionIds.remove(record.id);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: kIsWeb
              ? const Text(
                  'Database is not supported on web version, which is only for demonstration purposes.\nPlease use mobile app to save your values.',
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                )
              : StreamBuilder<List<SwimRecordItem>>(
                  stream: database.watchAllRecords(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }

                    if (snapshot.hasError) {
                      return Text('Failed to load records: ${snapshot.error}');
                    }

                    final dbRecords = snapshot.data ?? [];
                    _pendingDeletionIds
                        .removeWhere((id) => !dbRecords.any((r) => r.id == id));

                    final visibleRecords = dbRecords
                        .where((record) =>
                            !_pendingDeletionIds.contains(record.id))
                        .toList();
                    _records = _sortRecords(visibleRecords);
                    _syncSelectionWithRecords(_records);

                    if (_records.isEmpty) {
                      return const Text('No values saved yet.',
                          style: TextStyle(fontSize: 20));
                    }

                    return buildValueList();
                  },
                )),
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
                  Expanded(
                      child: Row(
                    children: [
                      SizedBox(width: 8),
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
                              _records.sort((a, b) =>
                                  b.dateCreated.compareTo(a.dateCreated));
                            } else {
                              _records.sort((a, b) =>
                                  a.dateCreated.compareTo(b.dateCreated));
                            }
                            selectedSort = value;
                          });
                        },
                      ),
                    ],
                  )),
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
                          },
                          icon: Icon(Icons.adaptive.share,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer),
                          tooltip: 'Export all records.',
                        ),
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
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer),
                      tooltip: 'Enable selection mode.'),
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
              )
            : ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
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
                            isSelectingView = !isSelectingView;
                          });
                        },
                        icon: Icon(Icons.check_box)),
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
