import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/controllers/items/units_controller.dart';
import 'package:lists/models/items/item.dart';
import 'package:lists/widgets/unit_dropdown.dart';

class ItemForm extends StatelessWidget {
  final Item item;
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
      //If the unit selected isnt already blank (in case of newunit creation or user selected blank and then modified)
      if (type == 'Modify')
        unitController.selected.value = item.unit.value;
      else if (type == 'New') unitController.selected.value = '';
    }
    final _formKey = ValueKey(item.uniqueID.toString());

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
                  color: Theme.of(context).cardColor),
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
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .color),
                            decoration: InputDecoration(
                              hintText: 'Name',
                              hintStyle: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .color),
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .secondaryHeaderColor)),
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
                        keyboardType: TextInputType.numberWithOptions(),
                        style: TextStyle(
                            color:
                                Theme.of(context).textTheme.bodyText1!.color),
                        decoration: InputDecoration(
                          hintText: 'Quantity',
                          suffixIcon: UnitDropDown(
                            unitController: unitController,
                            item: item,
                          ),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color:
                                      Theme.of(context).secondaryHeaderColor)),
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
                              if (nameController.text == '') {
                                _scaffoldMessengerKey.currentState!
                                    .showSnackBar(SnackBar(
                                        content:
                                            Text('Item Name cannot be empty')));
                              } else if (!GetUtils.isAlphabetOnly(
                                  nameController.text)) {
                                _scaffoldMessengerKey.currentState!
                                    .showSnackBar(SnackBar(
                                        content: Text(
                                            'Item Name can only contain alphabetic characters')));
                              } else if (quantityController.text == '') {
                                _scaffoldMessengerKey.currentState!
                                    .showSnackBar(SnackBar(
                                        content:
                                            Text('Quantity cannot be empty')));
                              } else if (!GetUtils.isNumericOnly(
                                  quantityController.text)) {
                                _scaffoldMessengerKey.currentState!
                                    .showSnackBar(SnackBar(
                                        content:
                                            Text('Quantity must be numeric')));
                              } else {
                                item.name.value = nameController.text;
                                item.quantity.value =
                                    int.parse(quantityController.text);
                                item.unit.value = unitController.selected.value;
                                Get.back(result: item);
                              }
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
