import 'package:code/csv_export.dart';
import 'package:code/data/database_drift.dart';
import 'package:code/main.dart';
import 'package:code/pdf_export.dart';
import 'package:flutter/material.dart';

class ExportDatabaseDialog extends StatelessWidget {
  const ExportDatabaseDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Export options'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              TextButton.icon(
                  onPressed: () async {
                    List<SwimRecordItem> dataToExport =
                        await database.allRecords;
                    if (dataToExport.isNotEmpty && context.mounted) {
                      exportRecordsToPDF(context, dataToExport);
                      Navigator.pop(context);
                    }
                  },
                  style: ButtonStyle(iconSize: WidgetStateProperty.all(20)),
                  icon: Icon(Icons.text_snippet_outlined),
                  label: Text(
                    'Export to PDF',
                    style: TextStyle(fontSize: 16),
                  ))
            ],
          ),
          Row(
            children: [
              TextButton.icon(
                  onPressed: () async {
                    List<SwimRecordItem> dataToExport =
                        await database.allRecords;
                    if (dataToExport.isNotEmpty && context.mounted) {
                      exportRecordsToCSV(context, dataToExport);
                      Navigator.pop(context);
                    }
                  },
                  style: ButtonStyle(iconSize: WidgetStateProperty.all(20)),
                  icon: Icon(Icons.archive_outlined),
                  label: Text(
                    'Export to CSV',
                    style: TextStyle(fontSize: 16),
                  ))
            ],
          )
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}
