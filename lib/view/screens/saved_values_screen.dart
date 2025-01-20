import 'dart:async';
import 'package:code/data/database_service.dart';
import 'package:code/model/all_values.dart';
import 'package:code/pdf_export.dart';
import 'package:code/view/widgets/database_list_tile.dart';
import 'package:code/view/widgets/info_database_dialog.dart';
import 'package:flutter/material.dart';

class SavedValuesScreen extends StatefulWidget {
  const SavedValuesScreen({super.key});

  @override
  State<SavedValuesScreen> createState() => _SavedValuesScreenState();
}

class _SavedValuesScreenState extends State<SavedValuesScreen> {
  late List<AllValues> _records = [];
  bool isLoading = false;
  final noteTextController = TextEditingController();
  bool isUndoPressed = false;
  Set<int> selectedSort = {1};

  Future<void> _getAllRecords() async {
    setState(() {
      isLoading = true;
    });

    _records = await DatabaseService.instance.getValues();

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    _getAllRecords();
    super.initState();
  }

  void editNoteDialog(AllValues record) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Edit note for this record'),
              Text(
                'Record from: ${record.date}',
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
                controller: noteTextController..text = record.noteText,
                maxLines: 3,
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.close_outlined),
                      color: Colors.red),
                  IconButton(
                    onPressed: () {
                      record.noteText = noteTextController.text;
                      DatabaseService.instance.updateValue(record);
                      Navigator.of(context).pop();
                      _getAllRecords();
                    },
                    icon: const Icon(Icons.save_outlined),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ],
              )
            ],
          ),
        );
      },
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
                final database = DatabaseService.instance;
                exportDatabaseToPdf(context, database);
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
                if (value != selectedSort) {
                  setState(() {
                    selectedSort = value;
                    _records = _records.reversed.toList();
                  });
                }
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
                  deleteValue: _deleteValue,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _deleteValue(AllValues record, int recordIndex) {
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
        DatabaseService.instance.deleteValue(record.id);
        isUndoPressed = false;
        setState(() {
          _getAllRecords();
        });
      }
    });
  }

  void displayUndoSnackbar(
      BuildContext context, AllValues record, int recordIndex) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Values of ${record.date} was deleted.'),
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
}
