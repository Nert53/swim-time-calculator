import 'package:code/csv_export.dart';
import 'package:code/csv_import.dart';
import 'package:code/data/database_drift.dart';
import 'package:code/main.dart';
import 'package:code/pdf_export.dart';
import 'package:code/view/screens/home_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class ExportDatabaseDialog extends StatelessWidget {
  final List<SwimRecordItem> dataToExport;
  const ExportDatabaseDialog({super.key, required this.dataToExport});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('File options'),
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
                  icon: Icon(Icons.article_outlined),
                  label: Text(
                    'Export PDF',
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
                  icon: Icon(Icons.table_chart_outlined),
                  label: Text(
                    'Export CSV',
                    style: TextStyle(fontSize: 16),
                  ))
            ],
          ),
          const Divider(),
          Row(
            children: [
              TextButton.icon(
                  onPressed: () async {
                    final result = await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['csv'],
                    );

                    if (result != null &&
                        result.files.single.path != null &&
                        context.mounted) {
                      importRecordsFromCSV(context, result.files.single.path!);

                      Navigator.of(context).pop();
                    } else if (context.mounted) {
                      Navigator.of(context).pop();
                      displaySnackBar(context, 'No file selected');
                    }
                  },
                  style: ButtonStyle(
                      iconSize: WidgetStateProperty.all(20),
                      foregroundColor: WidgetStateProperty.all(
                          Theme.of(context).colorScheme.tertiary)),
                  icon: Icon(Icons.upload_file_rounded),
                  label: Text(
                    'Import CSV',
                    style: TextStyle(fontSize: 16),
                  ))
            ],
          ),
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
