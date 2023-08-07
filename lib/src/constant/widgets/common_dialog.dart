
import 'package:flutter/material.dart';
import 'package:get_user/src/utils/media_query.dart';

class CommonDialog extends StatelessWidget {
  final Widget widget;

  const CommonDialog({super.key, required this.widget});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0)), //this right here
      child: SizedBox(
        width: (size(context: context).width >= 500)
            ? 340
            : size(context: context).width,
        child: Padding(padding: const EdgeInsets.all(12.0), child: widget),
      ),
    );
  }
}
