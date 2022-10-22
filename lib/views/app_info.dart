import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Recipedia/controllers/app_info_controller.dart';

class AppInfo extends GetView<AppInfoController> {
  const AppInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('App Info'),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          Card(
            child: ListTile(
              title: Center(child: Text("Credits")),
              subtitle: Column(children: [
                Text('App Icon created by Freepik - Flaticon'),
                Text("https://www.flaticon.com/free-icons/cooking"),
              ]),
            ),
          ),
          Card(
            child: Obx(
              () => ListTile(
                title: Text("Version"),
                subtitle: Text(controller.versionNumber.value),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
