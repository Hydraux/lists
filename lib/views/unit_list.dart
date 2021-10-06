import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/controllers/items/units_controller.dart';
import 'package:lists/widgets/item/item_card.dart';
import 'package:lists/widgets/dark_mode_button.dart';

class UnitList extends GetView<UnitsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          //backgroundColor: Theme.of(context).colorScheme.secondary,
          title: Center(child: Text('Unit List')),
          actions: <Widget>[darkModeButton()]),
      body: ListView.separated(
        itemCount: controller.editableList.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: UniqueKey(),
            onDismissed: (direction) {
              controller.removeUnit(index);
            },
            child: Text(
              controller.editableList[index].name,
              style: TextStyle(fontSize: 20),
            ),
          );
        },
        separatorBuilder: (context, index) => Divider(
          color: Theme.of(context).primaryColor,
          thickness: 3,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.addUnit(null);
        },
        child: Icon(Icons.add),
        heroTag: UnitList,
      ),
    );
  }
}
