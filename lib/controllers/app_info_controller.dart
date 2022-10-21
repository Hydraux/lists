import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppInfoController extends GetxController {
  final RxString versionNumber = RxString('');

  @override
  void onInit() async {
    versionNumber.value = await getVersionNumber();
    super.onInit();
  }

  Future<String> getVersionNumber() async {
    PackageInfo info = await PackageInfo.fromPlatform();
    return info.version;
  }
}
