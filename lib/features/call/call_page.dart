import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mini_chat/core/constants/locale_keys.dart';
import 'package:mini_chat/core/constants/app_images.dart';
import 'package:mini_chat/core/theme/app_colors.dart';
import 'package:mini_chat/core/theme/app_typography.dart';
import 'package:mini_chat/core/widgets/x_gradient_text.dart';
import 'package:mini_chat/core/widgets/x_scaffold.dart';
import 'package:mini_chat/features/call/call_controller.dart';

class CallPage extends GetView<CallController> {
  const CallPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return XScaffold(
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
          StringTranslateExtension(LocaleKeys.call).tr(),
          colors: const [Color.fromARGB(255, 8, 8, 11), AppColors.accent],
          style: AppTypography.heading1,
        ),
        action: FaIcon(
          FontAwesomeIcons.magnifyingGlass,
          color: isDark ? Colors.white : Colors.black,
        ),
      ),
      body: Column(
        children: [
          // Dynamic Top Divider
          Obx(() {
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
          // List of Calls
          Expanded(
            child: Obx(() {
              return ListView.separated(
                controller: controller.scrollController,
                physics: const BouncingScrollPhysics(),
                itemCount: controller.calls.length,
                separatorBuilder: (context, index) => Divider(
                  height: 1,
                  color: isDark ? AppColors.darkDivider : AppColors.divider,
                  indent: 80,
                  endIndent: 16,
                ),
                itemBuilder: (context, index) {
                  final call = controller.calls[index];
                  final isMissed = call['missed'] == true;
                  final isIncoming = call['type'] == 'incoming';

                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    leading: ClipOval(
                      child: call['avatar'].toString().isNotEmpty
                          ? Image.network(
                              call['avatar'],
                              width: 48,
                              height: 48,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              AppImages.image,
                              width: 48,
                              height: 48,
                              fit: BoxFit.cover,
                            ),
                    ),
                    title: Text(
                      call['name'],
                      style: AppTypography.subtitle1.copyWith(
                        color: isMissed
                            ? AppColors.error
                            : (isDark ? Colors.white : Colors.black),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Row(
                      children: [
                        Icon(
                          isIncoming ? Icons.call_received : Icons.call_made,
                          size: 16,
                          color: isMissed
                              ? AppColors.error
                              : (isIncoming
                                    ? AppColors.success
                                    : AppColors.textHint),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          call['time'],
                          style: AppTypography.bodyMedium.copyWith(
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        call['media'] == 'video' ? Icons.videocam : Icons.call,
                        color: AppColors.primary,
                      ),
                      onPressed: () {
                        // Handle call back
                      },
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
