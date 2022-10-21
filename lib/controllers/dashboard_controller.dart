import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DashboardController extends PageController {
  RxInt pageIndex = 0.obs;

  String getVersion() {
    String version = '';
    PackageInfo.fromPlatform().then((PackageInfo info) => version = info.version);
    return version;
  }
}
