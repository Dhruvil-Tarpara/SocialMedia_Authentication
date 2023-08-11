import 'package:flutter/material.dart';

class CommonExpansionTile extends StatelessWidget {
  final ExpansionTileController? controller;
  final Widget title;
  final List<Widget> children;
  const CommonExpansionTile(
      {super.key,
      required this.title,
      required this.children,
      this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: ExpansionTile(
        controller: controller,
        collapsedBackgroundColor: Colors.cyan.shade50,
        iconColor: Colors.indigo,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        collapsedShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        tilePadding: const EdgeInsets.symmetric(horizontal: 12),
        childrenPadding: EdgeInsets.zero,
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        title: title,
        children: children,
      ),
    );
  }
}
