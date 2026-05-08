import 'package:flutter/material.dart';
import 'package:mini_chat/core/theme/app_colors.dart';

class XScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget? body;
  final Widget? floatingActionButton;
  const XScaffold({
    super.key,
    this.appBar,
    this.body,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}

class XAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leading;
  final Widget? action;
  final String title;
  final double height;

  const XAppBar({
    super.key,
    this.leading,
    required this.title,
    this.action,
    this.height = kToolbarHeight,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leading,
      title: Text(title, style: const TextStyle(color: Colors.white)),
      actions: action != null ? [action!] : null,
      iconTheme: const IconThemeData(color: Colors.white),
      toolbarHeight: height,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.secondary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
