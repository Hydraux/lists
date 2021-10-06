import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/controllers/items/units_controller.dart';
import 'package:lists/models/items/item.dart';

class UnitDropDown extends StatelessWidget {
  final UnitsController unitController;
  final Item item;
  const UnitDropDown({required this.unitController, required this.item});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => DropdownButton(
        hint: Text('Unit'),
        onChanged: (newValue) {
          unitController.setSelected(newValue.toString(), item);
        },
        value: unitController.selected.value,
        items: unitController.unitList.map((selectedType) {
          return DropdownMenuItem(
            value: selectedType.name,
            child: new Text(
              selectedType.name,
            ),
          );
        }).toList(),
      ),
    );
  }
}
