import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lists/themes/custom_theme.dart';

class SettingsController extends GetxController {
  final GetStorage storage = GetStorage();
  final RxBool darkMode = RxBool(GetStorage().read('darkmode'));

  void toggleTheme() {
    darkMode.toggle();
    storage.write('darkmode', darkMode.value);
    Get.changeTheme(GetStorage().read('darkmode') ? darkTheme : lightTheme);
  }
}
