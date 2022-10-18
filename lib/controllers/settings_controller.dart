import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lists/themes/custom_theme.dart';

class SettingsController extends GetxController {
  final GetStorage storage = GetStorage();
  final RxBool darkMode = RxBool(GetStorage().read('darkMode'));

  SettingsController() {
    darkMode.value = storage.read('darkMode');
  }

  void toggleTheme() {
    darkMode.toggle();
    storage.write('darkMode', darkMode.value);
    Get.changeTheme(darkMode.value ? darkTheme : lightTheme);
  }
}
