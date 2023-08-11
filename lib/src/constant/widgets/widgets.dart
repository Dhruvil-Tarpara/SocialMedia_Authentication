import 'package:flutter/material.dart';
import 'text.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> commonShowSnackBar(
        BuildContext context, String text, Color color) =>
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: CommonText(text: text, color: color),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.white,
      ),
    );


class ConstSnackBar extends StatelessWidget {
  const ConstSnackBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}