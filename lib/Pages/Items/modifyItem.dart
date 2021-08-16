import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/Models/Items/Item.dart';
import 'package:lists/Models/Items/modifyItem.dart';
import 'package:lists/controllers/Items/Units.dart';

class ModifyItem extends StatelessWidget {
  final UnitsController unitController = Get.put(UnitsController());
  final Item item;
  ModifyItem({required this.item});

  @override
  Widget build(BuildContext context) {
    unitController.setSelected(item.unit.value);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              color: Theme.of(context).backgroundColor,
            ),
            height: 200,
            width: 300,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              child: Column(
                children: [
                  ModifyItemField(
                    item: item,
                    controller: item.controller!.itemName!,
                    name: 'Item Name',
                    autofocus: false,
                    suffix: null,
                  ),
                  ModifyItemField(
                    item: item,
                    controller: item.controller!.Quantity!,
                    name: 'Quantity',
                    autofocus: false,
                    suffix: Obx(
                      () => DropdownButton(
                        hint: Text('Unit'),
                        onChanged: (newValue) {
                          unitController.setSelected(newValue.toString());
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
                    ),
                  ),
                  Container(
                    height: 30,
                    child: Row(
                      children: [
                        IconButton(
                          //Confirm
                          onPressed: () {
                            item.name.value = item.controller!.itemName!.text;
                            item.quantity.value =
                                int.parse(item.controller!.Quantity!.text);
                            item.unit = unitController.selected;
                            Get.back();
                          },
                          icon: Icon(Icons.check_circle),
                        ),
                        new Spacer(),
                        IconButton(
                          //Cancel
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(Icons.cancel),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }
}
