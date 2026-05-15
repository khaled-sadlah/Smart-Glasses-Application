import 'package:flutter/material.dart';

enum SnackType { success, error, warning, info }

void showAppSnackBar(
  BuildContext context,
  String text, {
  SnackType type = SnackType.info,
  Duration duration = const Duration(seconds: 3),
}) {
  Color bg;
  switch (type) {
    case SnackType.success:
      bg = Colors.green;
      break;
    case SnackType.error:
      bg = Colors.red;
      break;
    case SnackType.warning:
      bg = Colors.orange;
      break;
    case SnackType.info:
    default:
      bg = Colors.black;
  }

  final w = MediaQuery.of(context).size.width;
  final fontSize = (w * 0.04).clamp(14.0, 18.0);

  final messenger = ScaffoldMessenger.of(context);
  messenger.clearSnackBars();

  messenger.showSnackBar(
    SnackBar(
      content: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
      backgroundColor: bg,
      duration: duration,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.symmetric(
        horizontal: (w * 0.06).clamp(12.0, 30.0),
        vertical: 10,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
    ),
  );
}

void showSnackBar(BuildContext context, String text) {
  showAppSnackBar(context, text, type: SnackType.info);
}
