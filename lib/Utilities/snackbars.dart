import 'package:flutter/material.dart';

class SnackBars {
  static void showNormalSnackbar(BuildContext context, String content) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(content),
        duration: const Duration(
          milliseconds: 2500,
        ),
      ),
    );
  }

  static void showErrorSnackBar(BuildContext context, String content) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(content),
        backgroundColor: const Color.fromARGB(255, 189, 86, 80),
        duration: const Duration(
          milliseconds: 2500,
        ),
      ),
    );
  }

  static void showNoInternetConnectionSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('No internet connection.'),
        duration: Duration(
          milliseconds: 2500,
        ),
      ),
    );
  }
}
