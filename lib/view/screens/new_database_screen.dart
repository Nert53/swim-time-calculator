import 'dart:async';
import 'package:code/data/database_drift.dart';
import 'package:code/main.dart';
import 'package:code/pdf_export.dart';
import 'package:code/view/widgets/database_list_tile2.dart';
import 'package:code/view/widgets/info_database_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewDatabaseScreen extends StatefulWidget {
  const NewDatabaseScreen({super.key});

  @override
  State<NewDatabaseScreen> createState() => _NewDatabaseScreenState();
}

class _NewDatabaseScreenState extends State<NewDatabaseScreen> {
  late List<SwimRecordItem> _records = [];
  bool isLoading = false;
  final noteTextController = TextEditingController();
  bool isUndoPressed = false;
  Set<int> selectedSort = {1};
  DateFormat dateFormat = DateFormat('dd-MM-yyyy (HH:mm)');

  Future<void> _getAllRecords() async {
    setState(() {
      isLoading = true;
    });

    _records = await database.allRecords;

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
                    fontStyle: FontStyle.italic),
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
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.close_outlined),
                      color: Colors.red),
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
              onPressed: () async {
                exportDatabaseToPdf(context);
              },
              icon: const Icon(
                Icons.file_download_outlined,
                color: Colors.black,
              )),
          IconButton(
            icon: const Icon(Icons.info_outline),
            color: Colors.black,
            tooltip: 'View help.',
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Sort by:', style: Theme.of(context).textTheme.titleSmall),
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
                    _records
                        .sort((a, b) => b.dateCreated.compareTo(a.dateCreated));
                  } else {
                    _records
                        .sort((a, b) => a.dateCreated.compareTo(b.dateCreated));
                  }
                  selectedSort = value;
                });
              },
            ),
          ],
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _records.length,
            itemBuilder: (context, index) {
              final record = _records[index];
              return Container(
                  margin: const EdgeInsets.all(8),
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
                      deleteRecord: deleteRecord));
            },
          ),
        ),
      ],
    );
  }
}
