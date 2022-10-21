import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/controllers/units_controller.dart';

class UnitsPage extends GetView<UnitsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        //backgroundColor: context.theme.colorScheme.secondary,
        title: Text('Unit List'),
      ),
      body: Obx(() {
        return Column(
          children: [
            ListView(
              shrinkWrap: true,
              children: controller.getListItems(controller.favorites),
            ),
            if (controller.favorites.length > 0)
              Divider(
                color: Get.theme.primaryColor,
                thickness: 2,
              ),
            ListView(
              shrinkWrap: true,
              children: controller.getListItems(controller.units),
            ),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.createUnit(null);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
