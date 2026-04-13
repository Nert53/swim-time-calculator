import 'package:flutter/material.dart';

class InfoDatabaseDialog extends StatelessWidget {
  const InfoDatabaseDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Explenations'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Icon(Icons.timer_outlined),
              SizedBox(width: 8),
              Text('... measured time'),
            ],
          ),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Icon(Icons.trending_up_outlined),
              SizedBox(width: 8),
              Text('... measured SR'),
            ],
          ),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Icon(Icons.straighten_outlined),
              SizedBox(width: 8),
              Text('... measured section length'),
            ],
          ),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Icon(Icons.notes_outlined),
              SizedBox(width: 8),
              Text('... editable note'),
            ],
          ),
          const Divider(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Icon(Icons.timer, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 8),
              const Text('... new swim time'),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Icon(
                Icons.trending_up,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              const Text('... calculated SR'),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              ImageIcon(
                const AssetImage('assets/icons/arrow_range.png'),
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              const Text('... calculated SL'),
            ],
          ),
          const Divider(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Icon(Icons.adaptive.share),
              const SizedBox(width: 8),
              const Text('... export / import options'),
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
