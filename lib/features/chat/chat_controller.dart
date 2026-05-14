import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  final searchQuery = ''.obs;
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

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  // Dummy data for users/conversations
  final allUsers = <Map<String, dynamic>>[
    {
      'name': 'Alice Johnson',
      'status': 'Online',
      'avatar': 'https://i.pravatar.cc/150?img=1',
    },
    {
      'name': 'Bob Smith',
      'status': 'Offline',
      'avatar': 'https://i.pravatar.cc/150?img=2',
    },
    {
      'name': 'Charlie Brown',
      'status': 'Online',
      'avatar': 'https://i.pravatar.cc/150?img=3',
    },
    {
      'name': 'Diana Prince',
      'status': 'Away',
      'avatar': 'https://i.pravatar.cc/150?img=4',
    },
    {
      'name': 'Eve Adams',
      'status': 'Online',
      'avatar': 'https://i.pravatar.cc/150?img=5',
    },
    {
      'name': 'Frank Miller',
      'status': 'Away',
      'avatar': 'https://i.pravatar.cc/150?img=6',
    },
    {
      'name': 'Grace Lee',
      'status': 'Online',
      'avatar': 'https://i.pravatar.cc/150?img=7',
    },
    {
      'name': 'Henry Ford',
      'status': 'Offline',
      'avatar': 'https://i.pravatar.cc/150?img=8',
    },
    {
      'name': 'Ivy Chen',
      'status': 'Online',
      'avatar': 'https://i.pravatar.cc/150?img=9',
    },
    {
      'name': 'Jack Wilson',
      'status': 'Away',
      'avatar': 'https://i.pravatar.cc/150?img=10',
    },
    {
      'name': 'Karen Davis',
      'status': 'Online',
      'avatar': 'https://i.pravatar.cc/150?img=11',
    },
    {
      'name': 'Leo Martinez',
      'status': 'Offline',
      'avatar': 'https://i.pravatar.cc/150?img=12',
    },
    {
      'name': 'Mia Taylor',
      'status': 'Online',
      'avatar': 'https://i.pravatar.cc/150?img=13',
    },
    {
      'name': 'Noah Thomas',
      'status': 'Online',
      'avatar': 'https://i.pravatar.cc/150?img=14',
    },
    {
      'name': 'Olivia White',
      'status': 'Away',
      'avatar': 'https://i.pravatar.cc/150?img=15',
    },
  ].obs;

  void onSearchChanged(String query) {
    searchQuery.value = query;
  }

  List<Map<String, dynamic>> get filteredUsers {
    if (searchQuery.value.isEmpty) {
      return allUsers;
    }
    return allUsers.where((user) {
      final name = user['name'].toString().toLowerCase();
      return name.contains(searchQuery.value.toLowerCase());
    }).toList();
  }
}
