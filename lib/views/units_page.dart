import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/controllers/units_controller.dart';

class UnitsPage extends GetView<UnitsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        //backgroundColor: Get.theme.colorScheme.secondary,
        title: Text('Unit List'),
      ),
      body: Obx(
        () => ListView(
          children: controller.unitWidgets,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.createUnit();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
