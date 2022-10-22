import 'package:get/get.dart';
import 'package:Recipedia/controllers/auth_controller.dart';
import 'package:Recipedia/controllers/dashboard_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
    Get.lazyPut<DashboardController>(() => DashboardController());
  }
}
