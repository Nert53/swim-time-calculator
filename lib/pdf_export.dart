import 'dart:io';
import 'package:code/constants.dart';
import 'package:code/data/database_drift.dart';
import 'package:code/functions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

Future<void> exportRecordsToPDF(
    BuildContext context, List<SwimRecordItem> data) async {
  String exportTime = DateFormat('dd-MM-yyyy HH-mm').format(DateTime.now());
  String fileName = 'swimTime_$exportTime.pdf';

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    },
  );

  if (data.isEmpty) {
    if (context.mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                Icons.error_outline,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              SizedBox(width: 8),
              Text('No saved values to export!',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary)),
            ],
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
    return;
  }

  final pdf = pw.Document();

  // Helper function to create data rows
  pw.TableRow createDataRow(String label, String value) {
    return pw.TableRow(
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.all(4),
          child: pw.Text(label),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(4),
          child: pw.Text(value),
        ),
      ],
    );
  }

  pw.Widget createRecordTable(SwimRecordItem record) {
    return pw.Container(
      width: 250, // Fixed width for each small table
      padding: const pw.EdgeInsets.all(8),
      child: pw.Table(
        border: pw.TableBorder.all(),
        columnWidths: {
          0: const pw.FlexColumnWidth(1.5),
          1: const pw.FlexColumnWidth(1),
        },
        children: [
          // Header with date
          pw.TableRow(
            decoration: pw.BoxDecoration(
              color: PdfColor.fromInt(umimplavatMainColor.value),
              border: pw.Border.all(
                  color: PdfColors.black, style: pw.BorderStyle.solid),
            ),
            children: [
              pw.Padding(
                padding: const pw.EdgeInsets.all(4),
                child: pw.Text(
                  'Type',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  textAlign: pw.TextAlign.center,
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(4),
                child: pw.Text(
                  'Value',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  textAlign: pw.TextAlign.center,
                ),
              ),
            ],
          ),
          // Data rows
          createDataRow('Created on', dateFormat.format(record.dateCreated)),
          createDataRow('Original Time [s]', '${record.originalTime}'),
          createDataRow('Original Stroke Rate [cycles/min]',
              '${record.originalStrokeRate}'),
          createDataRow('Section Length [m]', '${record.sectionLength}'),
          createDataRow('New Time [s]', '${record.newTime}'),
          createDataRow(
              'New Stroke Rate [cycles/min]', '${record.newStrokeRate}'),
          createDataRow('New Stroke Length [m]', '${record.newStrokeLength}'),
          // Note row
          pw.TableRow(
            decoration: pw.BoxDecoration(
              border: pw.Border.all(
                  color: PdfColors.black, style: pw.BorderStyle.solid),
            ),
            children: [
              pw.Padding(
                padding: const pw.EdgeInsets.all(4),
                child: pw.Text('Note', textAlign: pw.TextAlign.justify),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(4),
                child: record.note.isEmpty
                    ? pw.Text('(empty)',
                        style: pw.TextStyle(color: PdfColors.grey600))
                    : pw.Text(
                        replaceSpecialChars(record.note),
                        maxLines: 5,
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Create pages with tables
  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(32),
      build: (context) {
        List<pw.Widget> widgets = [];

        // Add title
        widgets.add(
          pw.Header(
            level: 0,
            child: pw.Text(
              'Swim Time Calculator ($exportTime)',
              style: pw.TextStyle(
                fontSize: 22,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
        );
        widgets.add(pw.SizedBox(height: 20));

        // Create rows of tables (2 tables per row)
        for (var i = 0; i < data.length; i += 2) {
          List<pw.Widget> rowChildren = [];

          // Add first table
          rowChildren.add(createRecordTable(data[i]));

          // Add second table if available
          if (i + 1 < data.length) {
            rowChildren.add(createRecordTable(data[i + 1]));
          }

          // Add row with tables
          widgets.add(
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
              children: rowChildren,
            ),
          );

          // spacing between rows
          widgets.add(pw.SizedBox(height: 20));
        }

        return widgets;
      },
    ),
  );

  // Get directory for saving file
  final Directory directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/$fileName');
  await file.writeAsBytes(await pdf.save());

  // hides loading indicator
  if (context.mounted) {
    Navigator.pop(context);
  }

  if (context.mounted) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Generating PDF completed'),
          content: Text(
              'File with records was created. If you want to save it or share, please use the button below.'),
          actions: [
            TextButton(
              onPressed: () async {
                if (await file.exists()) {
                  await file.delete();
                }
                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                try {
                  // place position for correctly render on iPad
                  final box = context.findRenderObject() as RenderBox?;

                  final fileParams = ShareParams(
                    subject: 'Swim Time Export ($exportTime)',
                    files: [XFile(file.path)],
                    sharePositionOrigin:
                        box!.localToGlobal(Offset.zero) & box.size,
                  );
                  SharePlus.instance.share(fileParams);

                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                } catch (e) {
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error saving PDF: ${e.toString()}'),
                      ),
                    );
                  }
                }
              },
              child: const Text('Save/Share'),
            ),
          ],
        );
      },
    );
  }
}
