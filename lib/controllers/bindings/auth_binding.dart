import 'package:get/get.dart';
import 'package:lists/controllers/auth_controller.dart';
import 'package:lists/controllers/dashboard_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
    Get.lazyPut<DashboardController>(() => DashboardController());
  }
}
