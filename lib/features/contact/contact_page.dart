import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mini_chat/core/constants/app_images.dart';
import 'package:mini_chat/core/constants/locale_keys.dart';
import 'package:mini_chat/core/theme/app_colors.dart';
import 'package:mini_chat/core/theme/app_typography.dart';
import 'package:mini_chat/core/widgets/x_gradient_text.dart';
import 'package:mini_chat/core/widgets/x_scaffold.dart';
import 'package:mini_chat/features/contact/contact_controller.dart';
import 'package:mini_chat/features/contact/widgets/invite_friend.dart';
import 'package:mini_chat/features/contact/widgets/alphabetical_contact_list.dart';
import 'package:get/get.dart';

class ContactPage extends GetView<ContactController> {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return XScaffold(
      appBar: XAppBar(
        titleWidget: XGradientText(
          StringTranslateExtension(LocaleKeys.contact).tr(),
          colors: const [Color.fromARGB(255, 8, 8, 11), AppColors.accent],
          style: AppTypography.heading1,
        ),
        leading: ClipOval(
          child: Image.asset(
            AppImages.image,
            width: 40,
            height: 35,
            fit: BoxFit.cover,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding:  EdgeInsets.all(16),
            child: InviteFriendCard(
              onTap: () {
                print("Invite Friends clicked from Contact Page!");
              },
            ),
          ),
          Obx(() {
            final isDark = Theme.of(context).brightness == Brightness.dark;
            return Container(
              height: 1,
              decoration: BoxDecoration(
                color: controller.isShow.value
                    ? (isDark ? AppColors.darkDivider : AppColors.divider)
                    : Colors.transparent,
                boxShadow: controller.isShow.value
                    ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          offset: const Offset(0, 1),
                          blurRadius: 2,
                        ),
                      ]
                    : null,
              ),
            );
          }),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only( left: 16, right: 16),
              child: Obx(() {
                return AlphabeticalContactList(
                  contacts: controller.contacts.toList(),
                  scrollController: controller.scrollController,
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
