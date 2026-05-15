import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini_chat/features/auth/auth_controller.dart';

class LoginPage extends GetView<AuthController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('Login Page')));
  }
}