import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini_chat/core/constants/app_images.dart';
import 'package:mini_chat/core/services/user_service.dart';
import 'package:mini_chat/core/theme/app_typography.dart';

class XProfile extends StatelessWidget {
  final double size;
  const XProfile({super.key, this.size = 40.0});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final userService = Get.find<UserService>();

    return Container(
      height: height * 0.1,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
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
      child: Obx(() {
        final user = userService.currentUser.value;
        final displayName = user?.name ?? 'Guest';
        final displayUsername = user?.username.isNotEmpty == true
            ? user!.username
            : '@${displayName.toLowerCase().replaceAll(' ', '_')}';
        final avatarUrl = user?.avatarUrl ?? '';

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const SizedBox(width: 16),
                CircleAvatar(
                  radius: 30,
                  backgroundImage: avatarUrl.isNotEmpty
                      ? NetworkImage(avatarUrl)
                      : AssetImage(AppImages.image) as ImageProvider,
                ),
                SizedBox(width: 16),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      style: AppTypography.bodyLarge.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      displayUsername,
                      style: AppTypography.bodySmall.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 24),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(10),
                    right: Radius.circular(10),
                  ),
                ),
                child: Text(
                  "Pro",
                  style: AppTypography.bodySmall.copyWith(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
