import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mini_chat/core/constants/locale_keys.dart';
import 'package:mini_chat/core/theme/app_colors.dart';
import 'package:mini_chat/core/theme/app_typography.dart';

class InviteFriendCard extends StatelessWidget {
  final VoidCallback onTap;

  const InviteFriendCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.primary,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            StringTranslateExtension(LocaleKeys.inviteFriendDesc).tr(),
            style: AppTypography.subtitle1.copyWith(
              color: isDark ? AppColors.darkTextPrimary : Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          _ButtonInviteFriend(onTap: onTap),
        ],
      ),
    );
  }
}

class _ButtonInviteFriend extends StatelessWidget {
  const _ButtonInviteFriend({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      child: Container(
        height: h * 0.045,
        width: w * 0.4,
        decoration: BoxDecoration(
          color: isDark ? AppColors.primary : AppColors.primaryLightest,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: Center(
          child: Text(
            StringTranslateExtension(LocaleKeys.inviteFriend).tr(),
            style: AppTypography.subtitle1.copyWith(
              color: isDark ? Colors.white : AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }
}
