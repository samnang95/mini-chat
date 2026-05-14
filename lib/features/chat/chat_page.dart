import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mini_chat/app/routes/app_routes.dart';
import 'package:mini_chat/core/constants/app_images.dart';
import 'package:mini_chat/core/constants/locale_keys.dart';
import 'package:mini_chat/core/theme/app_colors.dart';
import 'package:mini_chat/core/theme/app_typography.dart';
import 'package:mini_chat/core/widgets/x_gradient_text.dart';
import 'package:mini_chat/core/widgets/x_scaffold.dart';
import 'package:mini_chat/core/widgets/x_text_field.dart';
import 'package:mini_chat/features/chat/chat_controller.dart';

class ChatPage extends GetView<ChatController> {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: XAppBar(
        leading: ClipOval(
          child: Image.asset(
            AppImages.image,
            width: 40,
            height: 35,
            fit: BoxFit.cover,
          ),
        ),
        titleWidget: XGradientText(
          StringTranslateExtension(LocaleKeys.appName).tr(),
          colors: const [Color.fromARGB(255, 8, 8, 11), AppColors.accent],
          style: AppTypography.heading1,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 16, left: 16, top: 16),
            child: XTextField(
              prefixIcon: const FaIcon(FontAwesomeIcons.magnifyingGlass),
              suffixIcon: const FaIcon(Icons.mic),
              hintText: "Search conversations...",
              keyboardType: TextInputType.text,
              onChanged: controller.onSearchChanged,
            ),
          ),
          const SizedBox(height: 16),
          Obx(() {
            if (controller.isShow.value) {
              return Container(
                height: 1,
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.darkDivider
                      : AppColors.divider,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: const Offset(0, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          }),
          Expanded(
            child: Obx(() {
              final users = controller.filteredUsers;
              if (users.isEmpty) {
                return const Center(child: Text("No users found"));
              }
              return Scrollbar(
                controller: controller.scrollController,
                child: ListView.separated(
                  controller: controller.scrollController,
                  itemCount: users.length,
                  separatorBuilder: (context, index) => Divider(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.darkDivider
                        : AppColors.divider,
                    height: 1,
                    indent: 80,
                    endIndent: 16,
                  ),
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          radius: 24,
                          backgroundImage: NetworkImage(user['avatar']),
                        ),
                        title: Text(
                          user['name'],
                          style: AppTypography.subtitle1,
                        ),
                        subtitle: Text(
                          user['status'],
                          style: AppTypography.bodyMedium.copyWith(
                            color: user['status'] == 'Online'
                                ? AppColors.success
                                : AppColors.textHint,
                          ),
                        ),
                        onTap: () {
                          Get.toNamed(AppRoutes.chatDetailPage);
                        },
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
