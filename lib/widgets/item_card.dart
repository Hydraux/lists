import 'package:flutter/material.dart';
import 'package:fraction/fraction.dart';
import 'package:get/get.dart';
import 'package:lists/controllers/settings_controller.dart';
import 'package:lists/themes/custom_theme.dart';
import '../models/item.dart';

class ItemCard extends StatelessWidget {
  final int index;
  final Item item;
  final SettingsController settings = Get.find<SettingsController>();

  ItemCard({
    required this.item,
    required this.index,
    required bool editMode,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Obx(() => Text(
                      item.name,
                      style: TextStyle(
                          fontSize: 20,
                          color: settings.darkMode.value ? darkTheme.textTheme.bodyText2!.color : Colors.white),
                    )))),
        Expanded(
          flex: 0,
          child: Container(
              height: 30.0,
              child: Center(child: Obx(() {
                String quantity = item.quantity.toStringAsFixed(0);
                if (item.quantity % 1 != 0) {
                  quantity = item.quantity.toMixedFraction().toString();
                }
                return Text(
                  '$quantity ${item.unit}',
                  style: TextStyle(
                      fontSize: 20,
                      color: settings.darkMode.value ? darkTheme.textTheme.bodyText2!.color : Colors.white),
                );
              }))),
        ),
      ],
    );
  }
}
