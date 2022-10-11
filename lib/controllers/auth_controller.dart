import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/views/dashboard.dart';
import 'package:lists/views/login.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Rxn<User> _firebaseUser = Rxn<User>();

  String? get user => _firebaseUser.value?.uid;
  RxString get displayName {
    RxString name = RxString('');
    name.value = FirebaseAuth.instance.currentUser!.displayName!;
    return name;
  }

  @override
  void onInit() {
    _firebaseUser.bindStream(_auth.authStateChanges());
    _activateListeners();
    super.onInit();
  }

  void _activateListeners() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        Get.to(() => Login());
      } else {
        Get.to(() => DashboardPage());
      }
    });
  }

  void createUser(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      Get.off(() => DashboardPage());
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

      Get.off(() => DashboardPage());
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
