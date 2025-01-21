import 'package:code/data/database_service_old.dart';
import 'package:code/main.dart';
import 'package:code/model/all_values.dart';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';

part 'database_drift.g.dart';

class SwimRecordItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  RealColumn get originalTime => real()();
  RealColumn get originalStrokeRate => real()();
  RealColumn get sectionLength => real()();
  RealColumn get newTime => real()();
  RealColumn get newStrokeRate => real()();
  RealColumn get newStrokeLength => real()();
  TextColumn get note => text()();
  DateTimeColumn get dateCreated => dateTime()();
}

@DriftDatabase(tables: [SwimRecordItems])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
          await _importDataFromOldDatabase();
        },
      );

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'master_2',
      native: const DriftNativeOptions(
        databaseDirectory: getApplicationSupportDirectory,
      ),
    );
  }

  get oldRecordsCount => _importDataFromOldDatabase();

  addRecord(SwimRecordItemsCompanion record) {
    try {
      into(swimRecordItems).insert(record);
      return true;
    } catch (e) {
      return false;
    }
  }

  updateRecordById(SwimRecordItem record, int id) async {
    await (update(swimRecordItems)..where((tbl) => tbl.id.equals(id)))
        .write(record);
  }

  deleteRecordById(int id) async {
    await (delete(swimRecordItems)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<List<SwimRecordItem>> get allRecords => (select(swimRecordItems)
        ..orderBy([
          (t) =>
              OrderingTerm(expression: t.dateCreated, mode: OrderingMode.desc)
        ]))
      .get();

  Future<void> deleteAllRecords() async {
    await delete(swimRecordItems).go();
  }
}

_importDataFromOldDatabase() async {
  // Import data from old database
  List<AllValues> oldRecords = await DatabaseService.instance.getValues();
  for (var record in oldRecords) {
    var editedDate = record.date.replaceAll(' ', '');
    var year = editedDate.substring(12, 16);
    var month = editedDate.substring(9, 11);
    var day = editedDate.substring(6, 8);
    var hour = editedDate.substring(0, 2);
    var minute = editedDate.substring(3, 5);

    database.addRecord(SwimRecordItemsCompanion(
      originalTime: Value(record.originalTime),
      originalStrokeRate: Value(record.originalStrokeRate),
      sectionLength: Value(record.sectionLength),
      newTime: Value(record.newTime),
      newStrokeRate: Value(record.newStrokeRate),
      newStrokeLength: Value(record.newStrokeLength),
      note: Value(record.noteText),
      dateCreated: Value(DateTime(int.parse(year), int.parse(month),
          int.parse(day), int.parse(hour), int.parse(minute))),
    ));
  }

  return oldRecords.length;
}
