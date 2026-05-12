// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:get/get.dart';
// import 'package:mini_chat/core/constants/locale_keys.dart';
// import 'package:mini_chat/core/widgets/x_button_switch.dart';

// class SwichDarkMode extends StatefulWidget {
//   const SwichDarkMode({super.key});

//   @override
//   State<SwichDarkMode> createState() => _SwichDarkModeState();
// }

// class _SwichDarkModeState extends State<SwichDarkMode> {
//   // Initialize with current GetX theme mode
//   bool isDarkMode = Get.isDarkMode;

//   @override
//   Widget build(BuildContext context) {
//     return XButtonSwitch(
//       icon: isDarkMode ? FontAwesomeIcons.moon : FontAwesomeIcons.sun,
//       title: StringTranslateExtension(LocaleKeys.appearance).tr(),
//       value: isDarkMode,
//       onChanged: (val) {R
//         setState(() {
//           isDarkMode = val;
//         });
//         // Change the theme using GetX
//         Get.changeThemeMode(isDarkMode ? ThemeMode.dark : ThemeMode.light);
//       },
//     );
//   }
// }