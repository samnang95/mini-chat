import 'package:flutter/material.dart';
import 'package:mini_chat/core/theme/app_typography.dart';

class Subtitle extends StatelessWidget {
  final String title;
  const Subtitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Text(title.toUpperCase(), style: AppTypography.bodyMedium),
    );
  }
}
