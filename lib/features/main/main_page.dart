import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:mini_chat/core/theme/app_colors.dart';
import 'package:mini_chat/features/main/main_controller.dart';

class MainPage extends GetView<MainController> {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    return Scaffold(
      bottomNavigationBar: Container(
        width: double.infinity,
        height: h * 0.1,
        color: AppColors.primaryLighter,
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: h * 0.1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Icon(Icons.chat_bubble_outline), Text("chat")],
                ),
              ),
            ),
            Expanded(
              child: SizedBox(
                height: h * 0.1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Icon(Icons.people), Text("Contacts")],
                ),
              ),
            ),
            Expanded(
              child: SizedBox(
                height: h * 0.1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Icon(Icons.call), Text("Call")],
                ),
              ),
            ),
            Expanded(
              child: SizedBox(
                height: h * 0.1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Icon(Icons.settings), Text("Settings")],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
