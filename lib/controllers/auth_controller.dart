import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/controllers/dashboard_controller.dart';
import 'package:lists/views/dashboard.dart';
import 'package:lists/views/login.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Rxn<User> _firebaseUser = Rxn<User>();

  String? get user => _firebaseUser.value?.uid;
  RxString displayName = RxString('');

  @override
  void onInit() {
    _firebaseUser.bindStream(_auth.authStateChanges());
    _activateListeners();
    super.onInit();
  }

  void _activateListeners() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        Get.off(() => Login());
      } else {
        try {
          Get.find<DashboardController>();
        } catch (e) {
          Get.put(DashboardController());
        }
        Get.off(() => DashboardPage());
      }
    });

    FirebaseAuth.instance.userChanges().listen((User? user) {
      if (user != null && user.displayName != displayName.value && user.displayName != null) {
        displayName.value = user.displayName!;
      }
    });
  }

  void createUser(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        "Error creating account",
        e.message.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: Colors.black,
      );
    }
  }

  void login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        "Error Logging In",
        e.message.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: Colors.black,
      );
    }
  }

  void signOut() async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        "Error Signing Out",
        e.message.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: Colors.black,
      );
    }
  }
}
