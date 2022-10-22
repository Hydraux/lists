import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:Recipedia/themes/custom_theme.dart';

class SettingsController extends GetxController {
  final GetStorage storage = GetStorage();
  final RxBool darkMode = RxBool(GetStorage().read('darkMode'));
  final RxBool checkMethod =
      RxBool(GetStorage().read('checkMethod')); // Determines how ingredients are sent to the shopping list
  // True => checked items get sent
  // False => unchecked items get sent

  SettingsController() {
    darkMode.value = storage.read('darkMode');

    try {
      checkMethod.value = storage.read('checkMethod');
    } catch (e) {
      print(e);
      storage.write('checkMethod', true);
    }
  }

  void toggleTheme() {
    darkMode.toggle();
    storage.write('darkMode', darkMode.value);
    Get.changeTheme(darkMode.value ? darkTheme : lightTheme);
  }

  void toggleCheckMethod() {
    checkMethod.toggle();
    storage.write('checkMethod', checkMethod.value);
  }
}
