import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/controllers/items/item_controller.dart';
import 'package:lists/controllers/items/units_controller.dart';
import 'package:lists/controllers/recipes/recipe_controller.dart';
import 'package:lists/widgets/item/new_item.dart';

class NewDialogue extends StatelessWidget {
  NewDialogue({
    required this.textController,
    required this.name,
    required this.type,
    this.quantityController,
  });

  final String name;
  final String type;
  final TextEditingController textController;
  final TextEditingController? quantityController;
  final UnitsController unitController = Get.put(UnitsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              color: Theme.of(context).backgroundColor,
            ),
            height: getHeight(type),
            width: 300,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              child: Wrap(
                direction: Axis.horizontal,
                children: [
                  NewItemField(
                    controller: textController,
                    name: name,
                    autofocus: false,
                    suffix: null,
                  ),
                  if (type == 'item')
                    NewItemField(
                      controller: quantityController!,
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
                          onPressed: () {
                            if (type == 'item') {
                              Get.back(
                                  result: ItemController(null).makeItem(
                                      textController.text,
                                      int.parse(quantityController!.text),
                                      unitController.selected));
                            } else if (type == 'recipe') {
                              Get.back(
                                  result: RecipeController()
                                      .makeRecipe(textController.text));
                            } else if (type == 'step' || type == 'unit') {
                              Get.back(result: textController.text);
                            }
                          },
                          icon: Icon(Icons.check_circle),
                        ),
                        new Spacer(),
                        IconButton(
                            onPressed: () {
                              Get.back();
                            },
                            icon: Icon(Icons.cancel))
                      ],
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }

  double getHeight(String type) {
    if (type == 'item')
      return 200;
    else
      return 120;
  }
}
