import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lists/themes/custom_theme.dart';

class SettingsController extends GetxController {
  final RxBool darkMode = RxBool(!Get.isDarkMode);

  void toggleTheme() {
    darkMode.toggle();
    GetStorage().write('darkmode', darkMode.value);
    Get.changeTheme(GetStorage().read('darkmode') ? darkTheme : lightTheme);
  }
}
