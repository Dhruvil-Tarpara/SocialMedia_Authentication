import 'package:flutter/material.dart';

class CommonText extends StatelessWidget {
  final String text;
  final double? size;
  final FontWeight? fontWeight;
  final Color? color;
  final String? fontFamily;
  final TextOverflow? textOverflow;

  const CommonText({
    super.key,
    required this.text,
    this.color,
    this.size,
    this.fontWeight,
    this.fontFamily, this.textOverflow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: textOverflow,
      style: TextStyle(
        fontSize: size,
        fontWeight: fontWeight,
        color: color,
        fontFamily: fontFamily,
      ),
    );
  }
}
