import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini_chat/core/widgets/x_scaffold.dart';
import 'package:mini_chat/features/home/home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return XScaffold(
      appBar: XAppBar(title: "Home"),
    );
  }
}
