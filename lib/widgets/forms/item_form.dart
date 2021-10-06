import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/controllers/items/item_controller.dart';
import 'package:lists/controllers/items/units_controller.dart';
import 'package:lists/models/items/item.dart';
import 'package:lists/widgets/unit_dropdown.dart';

class ItemForm extends StatelessWidget {
  Item item;
  final String type;

  ItemForm({required this.item, required this.type});
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    if (item.name.toString() != 'Item Name')
      nameController.text = item.name.value;
    final quantityController = TextEditingController();
    quantityController.text = item.quantity.toString();
    final UnitsController unitController = Get.put(UnitsController());
    if (item.unit.toString() != '') {
      if (type == 'Modify')
        unitController.selected.value = item.unit.value;
      else if (type == 'New') unitController.selected.value = '';
    }
    final _formKey = ValueKey(item.UID.toString());

    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.transparent,
        body: Form(
          key: _formKey,
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                color: Theme.of(context).backgroundColor,
              ),
              height: 200,
              width: 300,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                child: Wrap(
                  direction: Axis.horizontal,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Focus(
                          child: TextFormField(
                            controller: nameController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              hintText: 'Item Name',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          onFocusChange: (hasFocus) {
                            if (!hasFocus && type == 'New') {
                              item.name.value = nameController.text;
                            }
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: quantityController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Quantity',
                          suffixIcon: UnitDropDown(
                            unitController: unitController,
                            item: item,
                          ),
                          border: OutlineInputBorder(),
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
                              item.name.value = nameController.text;
                              item.quantity.value =
                                  int.parse(quantityController.text);
                              item.unit.value = unitController.selected.value;
                              Get.back(result: item);
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
              ),
            ),
          ),
        ),
      ),
    );
  }
}
