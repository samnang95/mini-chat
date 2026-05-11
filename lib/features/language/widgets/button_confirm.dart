import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mini_chat/core/localization/locale_keys.dart';
import 'package:mini_chat/core/widgets/x_button.dart';

class ButtonConfirm extends StatelessWidget {
  final VoidCallback? onPressed;

  const ButtonConfirm({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0, top: 16.0),
      child: XButton(
        label: StringTranslateExtension(LocaleKeys.confirm).tr(),
        onPressed: onPressed ?? () => Get.back(),
      ),
    );
  }
}
