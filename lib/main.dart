import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:Recipedia/controllers/auth_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:Recipedia/themes/custom_theme.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Get.lazyPut((() => AuthController()));

  runApp(MyApp());
}

class MyApp extends GetWidget<AuthController> {
  final appdata = GetStorage();
  @override
  Widget build(BuildContext context) {
    appdata.writeIfNull('darkMode', false);
    appdata.writeIfNull('checkMethod', true);
    return SimpleBuilder(builder: (_) {
      bool isDarkMode = appdata.read('darkMode');
      Get.changeTheme(isDarkMode ? darkTheme : lightTheme);
      return GetMaterialApp(
        theme: isDarkMode ? darkTheme : lightTheme,
        home: Center(child: CircularProgressIndicator()),
      );
    });
  }
}
