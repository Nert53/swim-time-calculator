import 'package:code/model/all_values.dart';
import 'package:flutter/material.dart';

class DatabaseListTile extends StatelessWidget {
  final AllValues record;
  final int index;
  final Function(AllValues) editNoteDialog;
  final Function(AllValues, int) deleteValue;

  const DatabaseListTile(
      {super.key,
      required this.record,
      required this.index,
      required this.editNoteDialog,
      required this.deleteValue});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: Key(record.id),
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
                child: Text(
                    maxLines: 5, overflow: TextOverflow.clip, record.noteText),
              ),
            ],
          ),
        ],
      ),
      subtitle: Text('Saved on: ${record.date}',
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
              deleteValue(record, index);
            },
          ),
        ],
      ),
    );
  }
}
