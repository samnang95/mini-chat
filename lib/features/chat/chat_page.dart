import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mini_chat/core/constants/app_images.dart';
import 'package:mini_chat/core/constants/locale_keys.dart';
import 'package:mini_chat/core/theme/app_colors.dart';
import 'package:mini_chat/core/theme/app_typography.dart';
import 'package:mini_chat/core/widgets/x_gradient_text.dart';
import 'package:mini_chat/core/widgets/x_text_field.dart';
import 'package:mini_chat/features/chat/chat_controller.dart';

class ChatPage extends GetView<ChatController> {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipOval(
            child: Image.asset(
              AppImages.image,
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: XGradientText(
          StringTranslateExtension(LocaleKeys.appName).tr(),
          colors: const [AppColors.primary, AppColors.accent],
          style: AppTypography.heading1,
        ),
      ),
      body: Column(children: [
        XTextField()
      ],),
    );
  }
}
