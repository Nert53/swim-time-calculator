import 'dart:io';
import 'package:code/data/database_drift.dart';
import 'package:code/functions.dart';
import 'package:code/main.dart';
import 'package:csv/csv.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Future<bool> importRecordsFromCSV(
    BuildContext context, String pathToFile) async {
  DateFormat nameFormatter = DateFormat('dd-MM-yyyy HH:mm');

  final file = File(pathToFile);
  if (!await file.exists()) {
    if (context.mounted) {
      Navigator.pop(context);
      displaySnackBar(context, 'CSV file not found at $pathToFile');
    }
    return false;
  }

  final csvString = await file.readAsString();
  final csvRows = Csv(lineDelimiter: '\n').decode(csvString);

  // First row is header
  if (csvRows.isEmpty || csvRows.length < 2) {
    if (context.mounted) {
      Navigator.pop(context);
      displaySnackBar(context, 'File is empty or missing data');
    }
    return false;
  }

  // Get the record with the highest ID from the database
  final highestIdRecord = await (database.swimRecordItems.select()
        ..orderBy([(t) => OrderingTerm.desc(t.id)])
        ..limit(1))
      .get();
  int newStartingId =
      highestIdRecord.isNotEmpty ? highestIdRecord.first.id + 1 : 1;

  for (int i = 1; i < csvRows.length; i++) {
    final row = csvRows[i];
    SwimRecordItemsCompanion swimRecord = SwimRecordItemsCompanion(
      id: Value(newStartingId++),
      originalTime: Value(double.tryParse(row[1]) ?? 0.0),
      originalStrokeRate: Value(double.tryParse(row[2]) ?? 0.0),
      sectionLength: Value(double.tryParse(row[3]) ?? 0.0),
      newTime: Value(double.tryParse(row[4]) ?? 0.0),
      newStrokeRate: Value(double.tryParse(row[5]) ?? 0.0),
      newStrokeLength: Value(double.tryParse(row[6]) ?? 0.0),
      note: Value(row[7]),
      dateCreated: Value(nameFormatter.parse(row[8].toString())),
    );

    database.addRecord(swimRecord);
  }

  return true;
}
