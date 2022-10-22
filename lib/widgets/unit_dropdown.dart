import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Recipedia/controllers/units_controller.dart';
import 'package:Recipedia/models/item.dart';

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
          //border: Border.all(color: context.theme.secondaryHeaderColor),
          color: context.theme.secondaryHeaderColor,
        ),
        child: Obx(() {
          return DropdownButtonHideUnderline(
            child: DropdownButton(
              isExpanded: true,
              menuMaxHeight: 250,
              dropdownColor: context.theme.secondaryHeaderColor,
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
