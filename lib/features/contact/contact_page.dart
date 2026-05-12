import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:mini_chat/core/constants/app_images.dart';
import 'package:mini_chat/core/widgets/x_scaffold.dart';
import 'package:mini_chat/features/contact/contact_controller.dart';

class ContactPage extends GetView<ContactController> {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return XScaffold(appBar: XAppBar(title: "Hello", leading: ClipOval(
          child: Image.asset(
            AppImages.image,
            width: 40,
            height: 35,
            fit: BoxFit.cover,
          ),
        ),));
  }
}
