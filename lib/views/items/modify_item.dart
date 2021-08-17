import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/controllers/items/Item.dart';
import 'package:lists/controllers/items/units_controller.dart';
import 'package:lists/models/items/item.dart';
import 'package:lists/widgets/item/modify_item_field.dart';

class ModifyItem extends StatelessWidget {
  final UnitsController unitController = Get.put(UnitsController());

  final Item item;
  late final ItemController itemController;

  ModifyItem({required this.item}) {
    itemController = Get.find<ItemController>(tag: item.UID.toString());
  }

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
                    name: 'Item Name',
                    autofocus: false,
                    suffix: null,
                  ),
                  ModifyItemField(
                    item: item,
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
                            item.name.value = itemController.itemName!.text;
                            item.quantity.value =
                                int.parse(itemController.Quantity!.text);
                            item.unit.value = unitController.selected.value;
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
