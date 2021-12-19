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
  await Firebase.initializeApp(
      // options: FirebaseOptions(
      //     apiKey: "AIzaSyBEtzRxKOItpvY4WjFQLuQi5JAecsWKE_w",
      //     authDomain: "lists-cbae8.firebaseapp.com",
      //     databaseURL: "https://lists-cbae8-default-rtdb.firebaseio.com",
      //     projectId: "lists-cbae8",
      //     storageBucket: "lists-cbae8.appspot.com",
      //     messagingSenderId: "56686991386",
      //     appId: "1:56686991386:web:945071c4342a08e94519a3",
      //     measurementId: "G-CWJSV4C5LT"),
      );

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
}
