import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini_chat/core/services/user_service.dart';
import 'package:mini_chat/core/theme/app_colors.dart';
import 'package:mini_chat/core/theme/app_typography.dart';
import 'package:mini_chat/core/widgets/x_scaffold.dart';
import 'package:mini_chat/data/auth/models/user_model.dart';

class BlockedUsersPage extends StatelessWidget {
  const BlockedUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userService = Get.find<UserService>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return XScaffold(
      appBar: AppBar(
        title: Text(
          'Blocked Users',
          style: AppTypography.heading3.copyWith(
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        final blockedIds = userService.currentUser.value?.blockedUsers ?? [];
        if (blockedIds.isEmpty) {
          return Center(
            child: Text(
              'No blocked users.',
              style: AppTypography.bodyLarge.copyWith(
                color: isDark ? AppColors.darkTextHint : AppColors.textHint,
              ),
            ),
          );
        }

        return ListView.builder(
          itemCount: blockedIds.length,
          itemBuilder: (context, index) {
            final uid = blockedIds[index];
            return FutureBuilder<UserModel?>(
              future: userService.getUserById(uid),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const ListTile(
                    title: Text('Loading...'),
                  );
                }

                final user = snapshot.data!;
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: user.avatarUrl.isNotEmpty
                        ? NetworkImage(user.avatarUrl)
                        : null,
                    backgroundColor: AppColors.primary,
                    child: user.avatarUrl.isEmpty
                        ? Text(
                            user.name.isNotEmpty ? user.name.substring(0, 1).toUpperCase() : '?',
                            style: const TextStyle(color: Colors.white),
                          )
                        : null,
                  ),
                  title: Text(
                    user.name,
                    style: AppTypography.bodyLarge.copyWith(
                      color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: TextButton(
                    onPressed: () {
                      userService.toggleBlockUser(uid);
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary,
                    ),
                    child: const Text('Unblock'),
                  ),
                );
              },
            );
          },
        );
      }),
    );
  }
}
