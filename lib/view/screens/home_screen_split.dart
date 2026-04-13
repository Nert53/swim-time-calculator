import 'package:code/view/screens/home_screen_standard.dart';
import 'package:code/view/screens/saved_records_screen_split.dart';
import 'package:flutter/material.dart';

class HomeScreenSplit extends StatefulWidget {
  const HomeScreenSplit({super.key});

  @override
  State<HomeScreenSplit> createState() => _HomeScreenSplitState();
}

class _HomeScreenSplitState extends State<HomeScreenSplit> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: HomeScreenStandard(),
        ),
        VerticalDivider(
          thickness: 3,
        ),
        Expanded(flex: 3, child: SavedRecordsScreenSplit()),
      ],
    );
  }
}
