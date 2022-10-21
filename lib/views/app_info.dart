import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:lists/controllers/dashboard_controller.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppInfo extends GetView<DashboardController> {
  const AppInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          centerTitle: true,
          title: Text('App Info'),
        ),
        ListView(
          children: [
            ListTile(
              title: Text("Credits"),
              subtitle: Column(children: [
                Text('App Icon created by Freepik - Flaticon'),
                Text("https://www.flaticon.com/free-icons/cooking"),
              ]),
            ),
            ListTile(
              title: Text("Version"),
              subtitle: Text(controller.getVersion()),
            ),
          ],
        ),
      ],
    );
  }
}
