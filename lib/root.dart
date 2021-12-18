import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/views/dashboard.dart';
import 'package:lists/views/login.dart';

import 'controllers/auth_controller.dart';

class Root extends GetWidget<AuthController> {
  const Root({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return (Get.find<AuthController>().user != null) ? DashboardPage() : Login();
    });
  }
}
