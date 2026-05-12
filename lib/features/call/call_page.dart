import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mini_chat/core/constants/locale_keys.dart';
import 'package:mini_chat/core/widgets/x_scaffold.dart';
import 'package:mini_chat/features/call/call_controller.dart';

class CallPage extends GetView<CallController> {
  const CallPage({super.key});

  @override
  Widget build(BuildContext context) {
    return XScaffold(
      appBar: XAppBar(
        title: StringTranslateExtension(LocaleKeys.call).tr(),
        action: Icon(FontAwesomeIcons.magnifyingGlass),
      ),
    );
  }
}
