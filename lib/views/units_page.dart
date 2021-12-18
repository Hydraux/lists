import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/controllers/units_controller.dart';
import 'package:lists/widgets/dark_mode_button.dart';

class UnitsPage extends GetView<UnitsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          //backgroundColor: Theme.of(context).colorScheme.secondary,
          title: Center(child: Text('Unit List')),
          actions: <Widget>[darkModeButton()]),
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
