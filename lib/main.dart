import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lists/Pages/login.dart';
import 'package:lists/Pages/shopping_list.dart';

import 'Themes/custom_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
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
        theme: isDarkMode ? CustomTheme().darkTheme : CustomTheme().lightTheme,
        home: ShoppingList(),
      );
    });
  }

  void toggleTheme() {
    appdata.write('darkmode', !appdata.read('darkmode'));
    Get.changeTheme(appdata.read('darkmode')
        ? CustomTheme().darkTheme
        : CustomTheme().lightTheme);
  }
}

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool signedIn = false;
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) signedIn = true;
    });
    if (signedIn)
      return ShoppingList();
    else
      return LoginPage();
  }
}
