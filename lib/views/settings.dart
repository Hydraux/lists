import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/controllers/settings_controller.dart';
import 'package:lists/themes/custom_theme.dart';
import 'package:lists/views/units_page.dart';

class SettingsPage extends GetView<SettingsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text('Settings'),
      ),
      body: ListView(
        children: [
          Obx(() {
            return Card(
              child: SwitchListTile(
                  title: Text(
                    'Dark Mode',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  activeColor: darkTheme.textTheme.bodyText2!.color,
                  value: controller.darkMode.value,
                  onChanged: (value) {
                    controller.toggleTheme();
                  }),
            );
          }),
          Card(
            child: ListTile(
                onTap: () => Get.to(() => UnitsPage()),
                title: Text(
                  'Units',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                subtitle: Text('Modify list of units'),
                trailing: Obx(
                  () => Icon(
                    Icons.arrow_forward,
                    color: controller.darkMode.value ? darkTheme.textTheme.bodyText2!.color : Colors.white,
                  ),
                )),
          )
        ],
      ),
    );
  }

  Color getColor() {
    if (Get.isDarkMode) {
      return lightTheme.textTheme.bodyText2!.color!;
    }
    return darkTheme.textTheme.bodyText2!.color!;
  }
}
