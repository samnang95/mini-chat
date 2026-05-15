import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/animation.dart';
import 'package:mini_chat/app/routes/app_routes.dart';
import 'package:mini_chat/core/services/user_service.dart';

class SplashController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
    );

    animationController.forward();

    animationController.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        // Check if user is already logged in
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          // Load user profile from Firestore
          try {
            await Get.find<UserService>().loadCurrentUser();
          } catch (_) {
            // Firestore may be unavailable, continue anyway
          }
          Get.offAllNamed(AppRoutes.mainPage);
        } else {
          Get.offAllNamed(AppRoutes.startPage);
        }
      }
    });
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}

