import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:mini_chat/core/constants/app_animations.dart';
import 'package:mini_chat/core/theme/app_colors.dart';
import 'package:mini_chat/core/theme/app_typography.dart';
import 'package:mini_chat/core/widgets/x_button.dart';
import 'package:mini_chat/app/routes/app_routes.dart';
import 'package:mini_chat/features/start-page/start_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mini_chat/core/constants/locale_keys.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _lottieOpacity;
  late final Animation<double> _titleOpacity;
  late final Animation<Offset> _titleSlide;
  late final Animation<double> _subtitleOpacity;
  late final Animation<Offset> _subtitleSlide;
  late final Animation<double> _btn1Opacity;
  late final Animation<Offset> _btn1Slide;
  late final Animation<double> _btn2Opacity;
  late final Animation<Offset> _btn2Slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    // Lottie fades in first
    _lottieOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.4, curve: Curves.easeOut)),
    );

    // Title
    _titleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.2, 0.5, curve: Curves.easeOut)),
    );
    _titleSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.2, 0.5, curve: Curves.easeOutCubic)),
    );

    // Subtitle
    _subtitleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.3, 0.6, curve: Curves.easeOut)),
    );
    _subtitleSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.3, 0.6, curve: Curves.easeOutCubic)),
    );

    // Button 1
    _btn1Opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.5, 0.8, curve: Curves.easeOut)),
    );
    _btn1Slide = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.5, 0.8, curve: Curves.easeOutCubic)),
    );

    // Button 2
    _btn2Opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.6, 0.9, curve: Curves.easeOut)),
    );
    _btn2Slide = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.6, 0.9, curve: Curves.easeOutCubic)),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                FadeTransition(
                  opacity: _lottieOpacity,
                  child: Lottie.asset(
                    AppAnimations.letChat,
                    repeat: true,
                    reverse: false,
                    height: Get.height * 0.4,
                  ),
                ),
                FadeTransition(
                  opacity: _titleOpacity,
                  child: SlideTransition(
                    position: _titleSlide,
                    child: Text(
                      StringTranslateExtension(LocaleKeys.startPageTitle).tr(),
                      style: AppTypography.heading1,
                    ),
                  ),
                ),
                FadeTransition(
                  opacity: _subtitleOpacity,
                  child: SlideTransition(
                    position: _subtitleSlide,
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: Get.height * 0.02,
                        left: 20,
                        right: 20,
                      ),
                      child: Text(
                        StringTranslateExtension(LocaleKeys.startPageSubtitle).tr(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  FadeTransition(
                    opacity: _btn1Opacity,
                    child: SlideTransition(
                      position: _btn1Slide,
                      child: XButton(
                        label: StringTranslateExtension(
                          LocaleKeys.startPageSignIn,
                        ).tr(),
                        onPressed: () => Get.toNamed(AppRoutes.loginPage),
                      ),
                    ),
                  ),
                  SizedBox(height: Get.height * 0.015),
                  FadeTransition(
                    opacity: _btn2Opacity,
                    child: SlideTransition(
                      position: _btn2Slide,
                      child: XButton(
                        label: StringTranslateExtension(
                          LocaleKeys.startPageGetStarted,
                        ).tr(),
                        type: XButtonType.secondary,
                        onPressed: () => Get.toNamed(AppRoutes.registerPage),
                        backgroundColor: AppColors.primaryLighter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 1),
          ],
        ),
      ),
    );
  }
}
