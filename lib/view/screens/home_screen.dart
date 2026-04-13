import 'package:code/preference_service.dart';
import 'package:code/view/screens/home_screen_split.dart';
import 'package:code/view/screens/home_screen_standard.dart';
import 'package:code/view/widgets/menu_drawer.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  IosDeviceInfo? iosInfo;

  Future<void> _getDeviceInfo() async {
    iosInfo = await deviceInfo.iosInfo;

    setState(() {
      iosInfo = iosInfo;
    });
  }

  @override
  void initState() {
    super.initState();
    _getDeviceInfo();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
        stream: PreferenceService.onKeyChanged,
        builder: (context, snapshot) {
          return FutureBuilder<bool>(
              future: PreferenceService.getBool(
                'isSplitScreenMode',
                defaultValue: false,
              ),
              builder: (context, boolSnapshot) {
                final isSplitScreenMode = boolSnapshot.data ?? false;
                return Scaffold(
                    appBar: AppBar(
                      backgroundColor:
                          Theme.of(context).colorScheme.primaryContainer,
                      title: const Text(
                        'Swim Time Calculator',
                        style: TextStyle(fontSize: 24),
                      ),
                      centerTitle: true,
                      actions: [
                        Image.asset('assets/logo/UMIM_logo_circle_black.png',
                            height: 32)
                      ],
                      actionsPadding: const EdgeInsets.only(right: 16),
                    ),
                    drawer: const MenuDrawer(),
                    body: (iosInfo != null &&
                            iosInfo!.model.contains("iPad") &&
                            Orientation.landscape ==
                                MediaQuery.of(context).orientation &&
                            isSplitScreenMode)
                        ? const HomeScreenSplit()
                        : HomeScreenStandard());
              });
        });
  }
}
