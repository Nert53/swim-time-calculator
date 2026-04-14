import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:code/data/preference_service.dart';

class FeatureDialog extends StatefulWidget {
  const FeatureDialog({
    super.key,
  });

  @override
  State<FeatureDialog> createState() => _FeatureDialogState();
}

class _FeatureDialogState extends State<FeatureDialog> {
  int splitScreenFeature = 0;

  @override
  void initState() {
    super.initState();
    _loadSplitScreenFeatureCount();
  }

  Future<void> _loadSplitScreenFeatureCount() async {
    final count =
        await PreferenceService.getInt('splitScreenFeature', defaultValue: 0);

    if (!mounted) return;

    setState(() {
      splitScreenFeature = count;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          SvgPicture.asset(
            'assets/icons/party_popper.svg',
            height: 35,
            width: 35,
          ),
          SizedBox(width: 16),
          Text('New Feature!'),
        ],
      ),
      content: Text(
          'On larger devices (like iPad), you can now have the home screen split into 2 sections - calculator and saved values. \n\nYou can enable this feature in menu drawer on the left side.'),
      actions: [
        TextButton(
          onPressed: () async {
            Navigator.of(context).pop();
            await PreferenceService.setInt('splitScreenFeature', 5);
          },
          child: Text(
            'Don\'t show again',
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ),
        FilledButton(
          onPressed: () async {
            Navigator.of(context).pop();
            await PreferenceService.setInt(
                'splitScreenFeature', splitScreenFeature + 1);
          },
          child: Text('Got it!'),
        ),
      ],
    );
  }
}
