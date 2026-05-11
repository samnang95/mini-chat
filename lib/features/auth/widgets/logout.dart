import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mini_chat/core/localization/locale_keys.dart';
import 'package:mini_chat/core/theme/app_typography.dart';

class Logout extends StatelessWidget {
  const Logout({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      height: height * 0.07,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        boxShadow: isDark
            ? null
            : [
                const BoxShadow(
                  color: Color(0x1A000000), // 10% black
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
      ),
      child: Center(
        child: Text(
          StringTranslateExtension(LocaleKeys.logout).tr(),
          style: AppTypography.bodyLarge.copyWith(color: colorScheme.tertiary),
        ),
      ),
    );
  }
}
