import 'package:easy_localization/easy_localization.dart';

extension AppTranslations on String {
  String translate() {
    return StringTranslateExtension(this).tr();
  }
}