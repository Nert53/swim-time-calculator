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
  final csvRows = const CsvToListConverter().convert(csvString, eol: '\n');

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
      originalTime: Value(row[1]),
      originalStrokeRate: Value(row[2]),
      sectionLength: Value(row[3]),
      newTime: Value(row[4]),
      newStrokeRate: Value(row[5]),
      newStrokeLength: Value(row[6]),
      note: Value(row[7]),
      dateCreated: Value(nameFormatter.parse(row[8].toString())),
    );

    await database.addRecord(swimRecord);
  }

  return true;
}
