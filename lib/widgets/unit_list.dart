import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/controllers/units_controller.dart';

class UnitList extends GetWidget {
  const UnitList({
    required this.controller,
  });

  final UnitsController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return ListView(shrinkWrap: true, physics: ClampingScrollPhysics(), children: [
        ReorderableListView(
            shrinkWrap: true,
            children: controller.unitWidgets,
            onReorder: (oldIndex, newIndex) => controller.reorderList(oldIndex, newIndex))
      ]);
    });
  }
}
