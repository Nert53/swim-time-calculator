import 'dart:io';
import 'package:code/data/database_drift.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

Future<void> exportRecordsToCSV(
    BuildContext context, List<SwimRecordItem> data) async {
  DateFormat formatter = DateFormat('dd-MM-yyyy HH:mm');
  String exportTime = formatter.format(DateTime.now());
  String fileName = 'swimTime_$exportTime.csv';

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    },
  );

  if (data.isEmpty) {
    if (context.mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                Icons.error_outline,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              SizedBox(width: 8),
              Text('No saved values to export!',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary)),
            ],
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
    return;
  }

  // Process of covnerting list to CSV
  final rows = <List<dynamic>>[];
  rows.add(data.first.toJson().keys.toList());

  for (final record in data) {
    // Procces the date time for better readability
    final recordJson = record.toJson();
    recordJson['dateCreated'] = formatter.format(record.dateCreated);

    rows.add(recordJson.values.toList());
  }
  final csv = const ListToCsvConverter().convert(rows);

  // Get directory for saving file
  final Directory directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/$fileName');
  await file.writeAsString(csv);

  // hides loading indicator
  if (context.mounted) {
    Navigator.pop(context);
  }

  if (context.mounted) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Generating CSV completed'),
          content: Text(
              'File with records was created. If you want to save it or share, please use the button below.'),
          actions: [
            TextButton(
              onPressed: () async {
                if (await file.exists()) {
                  await file.delete();
                }
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                try {
                  // Use Share.shareXFiles for iOS compatibility
                  await Share.shareXFiles(
                    [XFile(file.path)],
                    subject: 'Swim Time Export ($exportTime)',
                  );
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                } catch (e) {
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error saving CSV: ${e.toString()}'),
                      ),
                    );
                  }
                }
              },
              child: const Text('Save/Share'),
            ),
          ],
        );
      },
    );
  }
}
