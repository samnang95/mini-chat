import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class CallController extends GetxController {
  final isShow = false.obs;
  final scrollController = ScrollController();

  final calls = <Map<String, dynamic>>[
    {
      'name': 'Aaron Smith',
      'avatar': '',
      'time': 'Today, 10:30 AM',
      'type': 'incoming',
      'media': 'voice',
      'missed': false,
    },
    {
      'name': 'Bob Williams',
      'avatar': '',
      'time': 'Today, 09:15 AM',
      'type': 'outgoing',
      'media': 'video',
      'missed': false,
    },
    {
      'name': 'Diana Ross',
      'avatar': '',
      'time': 'Yesterday, 08:45 PM',
      'type': 'incoming',
      'media': 'voice',
      'missed': true,
    },
    {
      'name': 'Frank Thomas',
      'avatar': '',
      'time': 'Yesterday, 07:00 PM',
      'type': 'outgoing',
      'media': 'voice',
      'missed': false,
    },
    {
      'name': 'Grace Lee',
      'avatar': '',
      'time': 'Monday, 11:20 AM',
      'type': 'incoming',
      'media': 'video',
      'missed': true,
    },
    {
      'name': 'Zack Snyder',
      'avatar': '',
      'time': 'Sunday, 02:30 PM',
      'type': 'outgoing',
      'media': 'video',
      'missed': false,
    },
    {
      'name': 'Alice Johnson',
      'avatar': '',
      'time': 'Saturday, 10:15 AM',
      'type': 'incoming',
      'media': 'voice',
      'missed': true,
    },
    {
      'name': 'Ben Carter',
      'avatar': '',
      'time': 'Saturday, 09:00 AM',
      'type': 'outgoing',
      'media': 'voice',
      'missed': false,
    },
    {
      'name': 'Charlie Davis',
      'avatar': '',
      'time': 'Friday, 04:20 PM',
      'type': 'incoming',
      'media': 'video',
      'missed': false,
    },
    {
      'name': 'Eve Adams',
      'avatar': '',
      'time': 'Friday, 01:10 PM',
      'type': 'outgoing',
      'media': 'video',
      'missed': true,
    },
    {
      'name': 'Liam Neeson',
      'avatar': '',
      'time': 'Thursday, 08:30 PM',
      'type': 'incoming',
      'media': 'voice',
      'missed': false,
    },
    {
      'name': 'Sophia Turner',
      'avatar': '',
      'time': 'Wednesday, 03:45 PM',
      'type': 'incoming',
      'media': 'video',
      'missed': true,
    },
    {
      'name': 'Noah Centineo',
      'avatar': '',
      'time': 'Tuesday, 11:30 AM',
      'type': 'outgoing',
      'media': 'voice',
      'missed': false,
    },
    {
      'name': 'Emma Watson',
      'avatar': '',
      'time': 'Monday, 09:45 AM',
      'type': 'incoming',
      'media': 'voice',
      'missed': false,
    },
    {
      'name': 'Oliver Smith',
      'avatar': '',
      'time': 'Last Week',
      'type': 'outgoing',
      'media': 'video',
      'missed': false,
    },
  ].obs;

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

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}