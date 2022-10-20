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
      body: Obx(
        () => ListView(
          children: controller.getListItems(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.createUnit(null);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
