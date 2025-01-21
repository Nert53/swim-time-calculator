import 'package:code/constants.dart';
import 'package:code/data/database_drift.dart';
import 'package:flutter/material.dart';

class DatabaseListTile extends StatelessWidget {
  SwimRecordItem record;
  final int index;
  final Function(SwimRecordItem) editNoteDialog;
  final Function(SwimRecordItem, int) deleteRecord;

  DatabaseListTile(
      {super.key,
      required this.record,
      required this.index,
      required this.editNoteDialog,
      required this.deleteRecord});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: Key(record.id.toString()),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              const Icon(Icons.timer_outlined),
              const SizedBox(width: 8),
              Text('${record.originalTime} s'),
            ],
          ),
          Row(
            children: <Widget>[
              const Icon(Icons.trending_up_outlined),
              const SizedBox(width: 8),
              Text('${record.originalStrokeRate} cycles/min'),
            ],
          ),
          Row(
            children: <Widget>[
              const Icon(Icons.straighten_outlined),
              const SizedBox(width: 8),
              Text('${record.sectionLength} m'),
            ],
          ),
          Row(
            children: <Widget>[
              Icon(
                Icons.timer,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text('${record.newTime} s'),
            ],
          ),
          Row(
            children: <Widget>[
              Icon(
                Icons.trending_up,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text('${record.newStrokeRate} cycles/min'),
            ],
          ),
          Row(
            children: <Widget>[
              ImageIcon(
                const AssetImage('assets/icons/arrow_range.png'),
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text('${record.newStrokeLength} m'),
            ],
          ),
          Row(
            children: <Widget>[
              const Icon(Icons.notes_outlined),
              const SizedBox(width: 8),
              Expanded(
                child:
                    Text(maxLines: 5, overflow: TextOverflow.clip, record.note),
              ),
            ],
          ),
        ],
      ),
      subtitle: Text('Saved on: ${dateFormat.format(record.dateCreated)}',
          style: const TextStyle(color: Colors.blueGrey)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(
              Icons.edit_note_outlined,
              size: 30,
            ),
            onPressed: () {
              editNoteDialog(record);
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.delete_outlined,
              color: Colors.red,
              size: 30,
            ),
            tooltip: 'Delete this value.',
            onPressed: () async {
              deleteRecord(record, index);
            },
          ),
        ],
      ),
    );
  }
}
