import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/controllers/units_controller.dart';
import 'package:lists/models/item.dart';
import 'package:lists/models/unit.dart';

class UnitDropDown extends StatelessWidget {
  final UnitsController unitController = Get.find<UnitsController>();
  final Item item;
  UnitDropDown({required this.item});

  @override
  Widget build(BuildContext context) {
    RxList<DropdownMenuItem<String>> unitList = unitController.unitList
        .map((Unit unit) {
          return DropdownMenuItem<String>(
            value: unit.name,
            child: Center(
              child: Text(
                unit.name,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Theme.of(context).textTheme.bodyText1!.color),
              ),
            ),
          );
        })
        .toList()
        .obs;

    RxList<DropdownMenuItem<String>> favoritesList = unitController.favoritesList
        .map((Unit favorite) {
          return DropdownMenuItem<String>(
            value: favorite.name,
            child: Center(
              child: Text(
                favorite.name,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Theme.of(context).textTheme.bodyText1!.color),
              ),
            ),
          );
        })
        .toList()
        .obs;

    DropdownMenuItem<String>? divider;
    if (favoritesList.isNotEmpty) {
      divider = DropdownMenuItem(
          enabled: false,
          child: Container(
            margin: EdgeInsets.all(0),
            padding: EdgeInsets.all(0),
            child: Divider(
              thickness: 2,
              color: Theme.of(context).appBarTheme.backgroundColor,
            ),
          ));
    }
    RxList<DropdownMenuItem<String>> dropDownList = favoritesList;
    if (divider != null) dropDownList.add(divider);
    dropDownList.addAll(unitList);

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
                unitController.setSelected(newValue, item);
              },
              value: unitController.selected.value.name,
              items: dropDownList,
            ),
          );
        }),
      ),
    );
  }
}
