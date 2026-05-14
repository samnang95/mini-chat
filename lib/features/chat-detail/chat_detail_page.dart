import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mini_chat/core/widgets/x_message_chat.dart';
import 'package:mini_chat/core/widgets/x_chat_date_header.dart';
import 'package:mini_chat/core/constants/app_images.dart';
import 'package:mini_chat/core/theme/app_typography.dart';
import 'package:mini_chat/core/widgets/x_scaffold.dart';
import 'package:mini_chat/core/widgets/x_text_field_chat.dart';
import 'package:mini_chat/features/chat-detail/chat_detail_controller.dart';

class ChatDetailPage extends GetView<ChatDetailController> {
  const ChatDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: XAppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        titleWidget: Obx(() {
          return Row(
            children: [
              ClipOval(
                child: controller.chatAvatar.value.isNotEmpty
                    ? Image.network(
                        controller.chatAvatar.value,
                        width: 36,
                        height: 36,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        AppImages.image,
                        width: 36,
                        height: 36,
                        fit: BoxFit.cover,
                      ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.chatName.value,
                    style: AppTypography.subtitle1.copyWith(
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    controller.chatStatus.value,
                    style: AppTypography.caption.copyWith(
                      color: Colors.black45,
                    ),
                  ),
                ],
              ),
            ],
          );
        }),
        action: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.video_call_rounded, color: Colors.black45),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.phone, color: Colors.black45),
              onPressed: () {},
            ),
          ],
        ),
      ),
      body: Obx(() {
        return ListView.builder(
          padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
          itemCount: controller.messages.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return const XChatDateHeader(date: "Today");
            }
            final msg = controller.messages[index - 1];
            return XMessageChat(
              isMe: msg['isMe'] as bool,
              message: msg['message'] as String? ?? "",
              time: msg['time'] as String,
              isRead: msg['isRead'] as bool? ?? false,
              type: msg['type'] as String? ?? 'text',
              mediaUrl: msg['mediaUrl'] as String?,
            );
          },
        );
      }),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                offset: const Offset(0, -2),
                blurRadius: 4,
              ),
            ],
          ),
          child: Row(
            children: [
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.plus, color: Colors.grey),
                onPressed: () {},
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: XTextFieldChat(
                  suffixIcon: FaIcon(
                    FontAwesomeIcons.smile,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const FaIcon(
                  FontAwesomeIcons.paperclip,
                  color: Colors.grey,
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: const FaIcon(
                  FontAwesomeIcons.paperPlane,
                  color: Colors.grey,
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
