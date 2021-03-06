import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/controllers/dashboard_controller.dart';
import 'package:lists/views/dashboard.dart';
import 'package:lists/views/login.dart';

import 'controllers/auth_controller.dart';

class Root extends GetWidget<AuthController> {
  const Root({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return (Get.find<AuthController>().user != null) ? getDashboardPage() : Login();
    });
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
