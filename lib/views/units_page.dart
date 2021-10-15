import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/controllers/units_controller.dart';
import 'package:lists/widgets/dark_mode_button.dart';
import 'package:lists/widgets/list_reorderable.dart';
import 'package:lists/widgets/unit_list.dart';

class UnitsPage extends GetView<UnitsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          //backgroundColor: Theme.of(context).colorScheme.secondary,
          title: Center(child: Text('Unit List')),
          actions: <Widget>[darkModeButton()]),
      body: ListView(
        children: <Widget>[
          ListReorderable(
            parentObject: this,
          ),
          if (controller.favoritesList.length > 0)
            Divider(
              thickness: 2,
              color: Theme.of(context).appBarTheme.backgroundColor,
            ),
          UnitList(controller: controller),
        ],
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
