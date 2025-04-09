import 'package:code/view/screens/saved_records_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets
            .zero, // zpusobi ze se menu zobrazi barevne od horniho okraje
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            child: const Text(
              'Swim Time Calculator',
              style: TextStyle(fontSize: 20),
            ),
          ),
          ListTile(
            leading: const Icon(FontAwesomeIcons.noteSticky),
            title: const Text('How to use'),
            onTap: () {
              _dialogInfo(
                  context,
                  'How to use',
                  '\na)	The coach sets the section length of the clean swim area that will be measured. If possible, we recommend using the standard clean swim area of 15-45 m (50m pool) or 10-20 m (25m pool). '
                      '\n\nb) The swimmer swims selected **section length**, while the coach measures the **time** and **SR**. '
                      '\n\nc) The coach inputs the **time** and **SR** in the app and press "calculate". The new swim time should  correspond the measured time (if not, please press the "calculate" button twice). '
                      '\n\nd) By adjsuting **SR/SL** you can observe potential changes in **new swim time**. '
                      '\n\n **SR**  ... stroke rate [cycles/min]'
                      '\n\n **SL** ... stroke length [m] '
                      '\n\n _Taping the "+" or "-" button will increase/decrease the value by 0.01 and while holding it will be changed by 0.1._');
            },
          ),
          ListTile(
            leading: const Icon(Icons.storage_rounded),
            title: const Text('Saved values'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const SavedRecordsScreen();
              }));
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About app'),
            onTap: () {
              _dialogInfo(
                context,
                'About app',
                'Version 2.0.0'
                    '\n\nOriginal idea: Raul Arellano '
                    '\n\nAuthor: umimplavat.cz '
                    '\n\nCreator: Vojtech Netrh '
                    '\n\nContact: umimplavat@gmail.com'
                    '\n\nPrivacy policy: www.umimplavat.vojtech-netrh.cz/swim-time.html'
                    '\n\nThis app calculates how potential changes in two key performance parameters - **stroke rate (_SR_)** and **stroke length (_SL_)** - affect the average clean swim time.'
                    ' **Swimming speed (_V_)** results from the optimal balance between **SR** and **SL** (_V = SR * SL_).'
                    ' Users can adjust **SR** and **SL** values to estimate potential average changes in clean swim time.'
                    ' The app calculates a new swim time by varying one parameter (e.g., increasing SR) while keeping the other constant, or by varying both parameters.'
                    ' This helps swimmers better understand how even small adjustments in **SR** or **SL** can significantly impact their swim times.',
              );
            },
          ),
        ],
      ),
    );
  }
}

Future<void> _dialogInfo(BuildContext context, String title, String content) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        scrollable: true,
        title: Text(title),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MarkdownBody(
                selectable: true,
                data: content,
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
