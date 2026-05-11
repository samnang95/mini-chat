import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mini_chat/core/theme/app_typography.dart';

class XButtonSwitch extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final VoidCallback? onTap;
  final bool isSwitch;
  final IconData? suffixIcon;

  const XButtonSwitch({
    super.key,
    required this.icon,
    required this.title,
    this.value = false,
    this.onChanged,
    this.onTap,
    this.isSwitch = true,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          width: double.infinity,
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: FaIcon(
                      icon,
                      size: 18,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    title,
                    style: AppTypography.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              isSwitch
                  ? Switch.adaptive(
                      value: value,
                      onChanged: onChanged,
                      // ignore: deprecated_member_use
                      activeColor: colorScheme.primary,
                    )
                  : FaIcon(
                      suffixIcon ?? FontAwesomeIcons.arrowRightLong,
                      size: 14,
                      color: colorScheme.onSurface,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
