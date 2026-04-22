import 'package:flutter/material.dart';

String replaceSpecialChars(String text) {
  return text
      .replaceAll('á', 'a')
      .replaceAll('é', 'e')
      .replaceAll('í', 'i')
      .replaceAll('ú', 'u')
      .replaceAll('ů', 'u')
      .replaceAll('ý', 'y')
      .replaceAll('š', 's')
      .replaceAll('č', 'c')
      .replaceAll('ř', 'r')
      .replaceAll('ž', 'z')
      .replaceAll('ť', 't')
      .replaceAll('ď', 'd')
      .replaceAll('ň', 'n');
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
