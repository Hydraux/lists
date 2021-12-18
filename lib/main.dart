import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lists/controllers/bindings/auth_binding.dart';
import 'package:lists/controllers/dashboard_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lists/root.dart';
import 'themes/custom_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp();

  Get.put<DashboardController>(DashboardController());
  if (FirebaseAuth.instance.currentUser != null) {}

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final appdata = GetStorage();
  @override
  Widget build(BuildContext context) {
    appdata.writeIfNull('darkmode', false);
    return SimpleBuilder(builder: (_) {
      bool isDarkMode = appdata.read('darkmode');
      return GetMaterialApp(
        initialBinding: AuthBinding(),
        theme: isDarkMode ? darkTheme : lightTheme,
        home: const Root(),
      );
    });
  }

  void toggleTheme() {
    appdata.write('darkmode', !appdata.read('darkmode'));
    Get.changeTheme(appdata.read('darkmode') ? darkTheme : lightTheme);
  }
}
