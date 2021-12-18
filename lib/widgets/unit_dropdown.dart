import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/controllers/units_controller.dart';
import 'package:lists/models/item.dart';

class UnitDropDown extends StatelessWidget {
  final UnitsController unitController = Get.find<UnitsController>();
  final Item item;
  UnitDropDown({required this.item});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.35,
      child: Container(
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Theme.of(context).secondaryHeaderColor),
          color: Theme.of(context).secondaryHeaderColor,
        ),
        child: Obx(() {
          return DropdownButtonHideUnderline(
            child: DropdownButton(
              isExpanded: true,
              menuMaxHeight: 250,
              dropdownColor: Theme.of(context).cardColor,
              onChanged: (newValue) {
                unitController.setSelected(newValue);
              },
              value: unitController.selected.value.name,
              items: unitController.getDropdownItems(),
            ),
          );
        }),
      ),
    );
  }
}
