import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:mini_chat/core/theme/app_colors.dart';
import 'package:mini_chat/core/theme/app_typography.dart';

class XButtonSwitch extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final VoidCallback? onTap;
  final bool isSwitch;

  const XButtonSwitch({
    super.key,
    required this.icon,
    required this.title,
    this.value = false,
    this.onChanged,
    this.onTap,
    this.isSwitch = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 2),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLightest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: FaIcon(
                      icon,
                      size: 18,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    title,
                    style: AppTypography.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              if (isSwitch)
                Switch.adaptive(
                  value: value,
                  onChanged: onChanged,
                  // ignore: deprecated_member_use
                  activeColor: AppColors.primary,
                )
              else
                const FaIcon(
                  FontAwesomeIcons.chevronRight,
                  size: 14,
                  color: AppColors.disabled,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
