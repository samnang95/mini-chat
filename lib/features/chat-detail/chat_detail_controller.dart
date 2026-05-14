import 'package:get/get.dart';

class ChatDetailController extends GetxController {
  final chatName = "Alice Johnson".obs;
  final chatStatus = "Online".obs;
  final chatAvatar = "".obs; // In a real app, pass the URL

  @override
  void onInit() {
    super.onInit();
    // If navigation passes user data via arguments, read it here
    if (Get.arguments != null) {
      final user = Get.arguments as Map<String, dynamic>;
      chatName.value = user['name'] ?? "Alice Johnson";
      chatStatus.value = user['status'] ?? "Online";
      chatAvatar.value = user['avatar'] ?? "";
    }
  }

  final messages = <Map<String, dynamic>>[
    {
      'isMe': false,
      'message': "Hey there! How's it going?",
      'time': "10:30 AM",
      'isRead': false,
    },
    {
      'isMe': true,
      'message': "I'm doing great, just working on a Flutter app. How about you?",
      'time': "10:32 AM",
      'isRead': true,
    },
    {
      'isMe': false,
      'message': "That sounds awesome! I love Flutter.",
      'time': "10:33 AM",
      'isRead': false,
    },
    {
      'isMe': true,
      'message': "Yeah it's super fast to build with.",
      'time': "10:34 AM",
      'isRead': true,
    },
    {
      'isMe': false,
      'message': "Are you using any state management? I've been trying GetX recently.",
      'time': "10:36 AM",
      'isRead': false,
    },
    {
      'isMe': true,
      'message': "Yes! GetX is exactly what I'm using. It makes routing and controllers so easy.",
      'time': "10:37 AM",
      'isRead': true,
    },
    {
      'isMe': false,
      'message': "Agreed. I used to use Provider but GetX requires so much less boilerplate.",
      'time': "10:39 AM",
      'isRead': false,
    },
    {
      'isMe': false,
      'message': "Have you tried building any complex animations with it yet?",
      'time': "10:39 AM",
      'isRead': false,
    },
    {
      'isMe': true,
      'message': "A little bit, mostly just standard page transitions and hero animations.",
      'time': "10:41 AM",
      'isRead': true,
    },
    {
      'isMe': true,
      'message': "Actually, right now I'm building out a chat UI component for my app. Trying to make it look super premium.",
      'time': "10:42 AM",
      'isRead': true,
    },
    {
      'isMe': false,
      'message': "Nice! Chat UIs can be tricky with the keyboard popping up and list scrolling.",
      'time': "10:44 AM",
      'isRead': false,
    },
    {
      'isMe': true,
      'message': "Tell me about it... Just got the dynamic bubbles and dark mode working though! 🚀",
      'time': "10:46 AM",
      'isRead': true,
    },
    {
      'isMe': false,
      'message': "That's awesome! You'll have to show me a demo when it's done.",
      'time': "10:50 AM",
      'isRead': false,
    },
    {
      'isMe': true,
      'message': "For sure. I'll send you a TestFlight link later today.",
      'time': "10:52 AM",
      'isRead': false,
    },
    {
      'isMe': false,
      'type': 'image',
      'mediaUrl': 'https://images.unsplash.com/photo-1617042375876-a13e36732a04?auto=format&fit=crop&w=400&q=80',
      'time': "10:55 AM",
      'isRead': false,
    },
    {
      'isMe': true,
      'type': 'voice',
      'time': "10:56 AM",
      'isRead': true,
    },
    {
      'isMe': false,
      'type': 'location',
      'message': 'Meet me at the coffee shop here!',
      'time': "11:00 AM",
      'isRead': false,
    },
    
  ].obs;
}