import 'package:flutter/material.dart';

class XGradientText extends StatelessWidget {
  const XGradientText(
    this.text, {
    super.key,
    required this.colors,
    this.style,
    this.begin = Alignment.centerLeft,
    this.end = Alignment.centerRight,
    this.textAlign,
    this.overflow,
    this.maxLines,
  });

  final String text;
  final List<Color> colors;
  final TextStyle? style;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => LinearGradient(
        colors: colors,
        begin: begin,
        end: end,
      ).createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(
        text,
        textAlign: textAlign,
        overflow: overflow,
        maxLines: maxLines,
        style: (style ?? const TextStyle()).copyWith(color: Colors.white),
      ),
    );
  }
}
