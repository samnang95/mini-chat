import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactController extends GetxController {
  final isShow = false.obs;
  final scrollController = ScrollController();
  
  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(() {
      if (scrollController.offset > 0) {
        if (!isShow.value) isShow.value = true;
      } else {
        if (isShow.value) isShow.value = false;
      }
    });
  }

  final contacts = <Map<String, dynamic>>[
    {'name': 'Alice Johnson', 'status': 'Available', 'avatar': ''},
    {'name': 'Aaron Smith', 'status': 'Busy', 'avatar': ''},
    {'name': 'Bob Williams', 'status': 'At the gym', 'avatar': ''},
    {'name': 'Ben Carter', 'status': 'Coding 💻', 'avatar': ''},
    {'name': 'Charlie Davis', 'status': 'In a meeting', 'avatar': ''},
    {'name': 'Diana Ross', 'status': 'Out for lunch', 'avatar': ''},
    {'name': 'Eve Adams', 'status': 'Sleeping 😴', 'avatar': ''},
    {'name': 'Frank Thomas', 'status': 'Available', 'avatar': ''},
    {'name': 'Grace Lee', 'status': 'Urgent calls only', 'avatar': ''},
    {'name': 'Zack Snyder', 'status': 'Filming', 'avatar': ''},
  ].obs;
}
