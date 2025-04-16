import 'package:code/constants.dart';
import 'package:code/data/database_drift.dart';
import 'package:code/main.dart';
import 'package:code/view/widgets/menu_drawer.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hold_down_button/hold_down_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final timeController = TextEditingController();
  final strokeRateController = TextEditingController();
  final sectionLengthController = TextEditingController();
  final resultTimeController = TextEditingController();
  final strokeRateController2 = TextEditingController();
  final strokeLengthController = TextEditingController();
  final noteTextDialogController = TextEditingController();

  var resulTimeColor = Colors.black;
  bool calculateButtonClick = false;

  @override
  void initState() {
    strokeRateController2.addListener(() {
      updateResultTime();
    });
    strokeLengthController.addListener(() {
      updateResultTime();
      super.initState();
    });
  }

  void initialCalculation() {
    calculateButtonClick = true;
    if (timeController.text.isEmpty ||
        strokeRateController.text.isEmpty ||
        sectionLengthController.text.isEmpty) {
      displaySnackBar(context, 'Please fill in all fields!');
      return;
    }

    final time = double.parse(timeController.text);
    final strokeRate = double.parse(strokeRateController.text);
    final length = double.parse(sectionLengthController.text);

    double strokeTime = 60 / strokeRate;
    double avgSpeed = length / time;
    double strokeLength = avgSpeed * strokeTime;

    setState(() {
      resultTimeController.text = time.toStringAsFixed(2);
      strokeRateController2.text = strokeRate.toStringAsFixed(2);
      strokeLengthController.text = strokeLength.toStringAsFixed(2);
    });
  }

  double newSectionTime(double length, double strokeLength, double strokeTime) {
    return length / strokeLength * strokeTime;
  }

  void updateResultTime() {
    final sectionLength = double.parse(sectionLengthController.text);
    final strokeLength = double.parse(strokeLengthController.text);
    final strokeTime = 60 / double.parse(strokeRateController2.text);

    if (calculateButtonClick) {
      resultTimeController.text = double.parse(timeController.text)
          .toStringAsFixed(
              2); // value will always be displayed wit 2 decimal places
      updateResultTimeColor();
      calculateButtonClick = false;
      return;
    }

    setState(() {
      resultTimeController.text =
          newSectionTime(sectionLength, strokeLength, strokeTime)
              .toStringAsFixed(2);
      updateResultTimeColor();
    });
  }

  void updateResultTimeColor() {
    final originalTime = double.parse(timeController.text);
    final resultTime = double.parse(resultTimeController.text);

    if (resultTime > originalTime) {
      resulTimeColor = Colors.red;
    }
    if (resultTime < originalTime) {
      resulTimeColor = Colors.green;
    }
    if (resultTime == originalTime) {
      resulTimeColor = Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          title: const Text(
            'Swim Time Calculator',
            style: TextStyle(fontSize: 24),
          ),
          centerTitle: true,
        ),
        drawer: const MenuDrawer(),
        bottomNavigationBar: const Padding(
          padding: EdgeInsets.only(bottom: 4.0),
          child: Image(
            image: AssetImage('assets/images/UMIM_logo_RGB-10.png'),
            height: 50,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 380, minWidth: 340),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    TextField(
                      controller: sectionLengthController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: <TextInputFormatter>[
                        // allow only numbers and dot/comma and comma is replaced with dot
                        FilteringTextInputFormatter.allow(
                            RegExp(r'(^-?\d*[.,]?\d*)')),
                        TextInputFormatter.withFunction(
                          (oldValue, newValue) => newValue.copyWith(
                            text: newValue.text.replaceAll(',', '.'),
                          ),
                        ),
                      ],
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.straighten),
                        border: OutlineInputBorder(),
                        labelText: 'Section Length [m]',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: timeController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                            RegExp(r'(^-?\d*[.,]?\d*)')),
                        TextInputFormatter.withFunction(
                          (oldValue, newValue) => newValue.copyWith(
                            text: newValue.text.replaceAll(',', '.'),
                          ),
                        ),
                      ],
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.timer_outlined),
                        border: OutlineInputBorder(),
                        labelText: 'Time [s]',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: strokeRateController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                            RegExp(r'(^-?\d*[.,]?\d*)')),
                        TextInputFormatter.withFunction(
                          (oldValue, newValue) => newValue.copyWith(
                            text: newValue.text.replaceAll(',', '.'),
                          ),
                        ),
                      ],
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.trending_up),
                        border: OutlineInputBorder(),
                        labelText: 'Stroke Rate [cycles/min]',
                      ),
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: initialCalculation,
                            child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(FontAwesomeIcons.calculator),
                                  SizedBox(width: 8),
                                  Text(
                                    'Calculate',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  )
                                ]),
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              timeController.clear();
                              strokeRateController.clear();
                              sectionLengthController.clear();
                              resultTimeController.clear();
                              strokeRateController2.clear();
                              strokeLengthController.clear();
                            });
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.errorContainer),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.delete_forever,
                                  size: 26,
                                  color: Theme.of(context).colorScheme.error,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Clear',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                                )
                              ]),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    TextField(
                      controller: resultTimeController,
                      readOnly: true,
                      style: TextStyle(
                          color: resulTimeColor, fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.label_important_outline),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                              width: 2),
                        ),
                        labelText: 'New swim time [s]',
                      ),
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: Column(
                          children: [
                            TextField(
                              controller: strokeRateController2,
                              readOnly: true,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            const Text('Stroke Rate'),
                            const Text('[cycles/min]'),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                HoldDownButton(
                                  onHoldDown: () {
                                    setState(() {
                                      final oldSR = double.parse(
                                          strokeRateController2.text);
                                      final newSR = oldSR + 0.1;
                                      if (newSR > 0) {
                                        strokeRateController2.text =
                                            (newSR).toStringAsFixed(2);
                                      }
                                    });
                                  },
                                  child: FloatingActionButton(
                                    elevation: 3,
                                    onPressed: () {
                                      setState(() {
                                        final oldSR = double.parse(
                                            strokeRateController2.text);
                                        final newSR = oldSR + 0.01;
                                        if (newSR > 0) {
                                          strokeRateController2.text =
                                              (newSR).toStringAsFixed(2);
                                        }
                                      });
                                    },
                                    child: const Icon(Icons.add_outlined),
                                  ),
                                ),
                                HoldDownButton(
                                  onHoldDown: () {
                                    setState(() {
                                      final oldSR = double.parse(
                                          strokeRateController2.text);
                                      final newSR = oldSR - 0.1;
                                      if (newSR > 0) {
                                        strokeRateController2.text =
                                            (newSR).toStringAsFixed(2);
                                      }
                                    });
                                  },
                                  child: FloatingActionButton(
                                    elevation: 3,
                                    onPressed: () {
                                      setState(() {
                                        final oldSR = double.parse(
                                            strokeRateController2.text);
                                        final newSR = oldSR - 0.01;
                                        if (newSR > 0) {
                                          strokeRateController2.text =
                                              (newSR).toStringAsFixed(2);
                                        }
                                      });
                                    },
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .secondaryContainer,
                                    child: const Icon(Icons.remove_outlined),
                                  ),
                                ),
                              ],
                            )
                          ],
                        )),
                        const SizedBox(
                          width: 12,
                        ),
                        Expanded(
                            child: Column(
                          children: [
                            TextField(
                              controller: strokeLengthController,
                              readOnly: true,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            const Text('Stroke Length'),
                            const Text('[m]'),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                HoldDownButton(
                                  onHoldDown: () {
                                    setState(() {
                                      final oldSL = double.parse(
                                          strokeLengthController.text);
                                      final newSL = oldSL + 0.1;
                                      if (newSL > 0) {
                                        strokeLengthController.text =
                                            (newSL).toStringAsFixed(2);
                                      }
                                    });
                                  },
                                  child: FloatingActionButton(
                                    elevation: 3,
                                    onPressed: () {
                                      setState(() {
                                        final oldSL = double.parse(
                                            strokeLengthController.text);
                                        final newSL = oldSL + 0.01;

                                        if (newSL > 0) {
                                          strokeLengthController.text =
                                              (newSL).toStringAsFixed(2);
                                        }
                                      });
                                    },
                                    child: const Icon(Icons.add_outlined),
                                  ),
                                ),
                                HoldDownButton(
                                  onHoldDown: () {
                                    setState(() {
                                      final oldSL = double.parse(
                                          strokeLengthController.text);
                                      final newSL = oldSL - 0.1;
                                      if (newSL > 0) {
                                        strokeLengthController.text =
                                            (newSL).toStringAsFixed(2);
                                      }
                                    });
                                  },
                                  child: FloatingActionButton(
                                    elevation: 3,
                                    onPressed: () {
                                      setState(() {
                                        final oldSL = double.parse(
                                            strokeLengthController.text);
                                        final newSL = oldSL - 0.01;
                                        if (newSL > 0) {
                                          strokeLengthController.text =
                                              (newSL).toStringAsFixed(2);
                                        }
                                      });
                                    },
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .secondaryContainer,
                                    child: const Icon(Icons.remove),
                                  ),
                                )
                              ],
                            ),
                          ],
                        )),
                      ],
                    ),
                    const SizedBox(
                      height: 28,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (resultTimeController.text.isNotEmpty) {
                          saveValues();
                        } else {
                          displaySnackBar(
                              context, 'Please calculate the new time first!');
                        }
                      },
                      child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.save),
                            SizedBox(width: 8),
                            Text(
                              "Save Values",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            )
                          ]),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  void saveValues() async {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Save values'),
                  Text(
                    'Date created: ${dateFormat.format(DateTime.now())}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  SizedBox(height: 4),
                ],
              ),
              content: TextField(
                controller: noteTextDialogController,
                decoration: const InputDecoration(
                    labelText: 'Note for record', border: OutlineInputBorder()),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    noteTextDialogController.clear();
                    Navigator.pop(context);
                  },
                  child: Text('Cancel', style: TextStyle(color: errorColor)),
                ),
                FilledButton(
                  onPressed: () {
                    doSaveValues(noteTextDialogController.text);
                    noteTextDialogController.clear();
                    Navigator.pop(context);
                  },
                  child: const Text('Save'),
                ),
              ],
            ));
  }

  void doSaveValues(String noteText) async {
    SwimRecordItemsCompanion newRecord = SwimRecordItemsCompanion(
        originalTime: drift.Value(double.parse(timeController.text)),
        originalStrokeRate:
            drift.Value(double.parse(strokeRateController.text)),
        sectionLength: drift.Value(double.parse(sectionLengthController.text)),
        newTime: drift.Value(double.parse(resultTimeController.text)),
        newStrokeRate: drift.Value(double.parse(strokeRateController2.text)),
        newStrokeLength: drift.Value(double.parse(strokeLengthController.text)),
        dateCreated: drift.Value(DateTime.now()),
        note: drift.Value(noteText));

    if (await database.addRecord(newRecord) != null) {
      displaySnackBar(context, 'Values saved successfully!',
          color: Colors.green);
    } else {
      displaySnackBar(context, 'Values could not be saved!', color: errorColor);
    }
  }
}

void displaySnackBar(BuildContext context, String message,
    {Color color = Colors.grey}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(milliseconds: 2500),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
  );
}
