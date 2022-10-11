import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/controllers/dashboard_controller.dart';
import 'package:lists/views/dashboard.dart';
import 'package:lists/views/login.dart';

import 'controllers/auth_controller.dart';

class Root extends GetWidget<AuthController> {
  Root() {
    Timer(Duration(seconds: 1), () {
      controller.user == null ? Get.to(() => Login()) : Get.to(() => getDashboardPage());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget getDashboardPage() {
    try {
      Get.find<DashboardController>();
    } catch (e) {
      Get.put<DashboardController>(DashboardController());
    }
    return DashboardPage();
  }
}
