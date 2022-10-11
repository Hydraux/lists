import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/controllers/items_controller.dart';
import 'package:lists/controllers/units_controller.dart';
import 'package:lists/models/item.dart';
import 'package:fraction/fraction.dart';
import 'package:lists/widgets/unit_dropdown.dart';

// ignore: must_be_immutable
class ItemForm extends StatelessWidget {
  final BorderRadius _borderRadius = BorderRadius.all(Radius.circular(10));
  Item item;
  final String type;
  final UnitsController unitController = Get.find<UnitsController>();

  ItemForm({required this.item, required this.type});

  Widget build(BuildContext context) {
    final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
    final ItemsController controller = ItemsController(tag: 'itemForm');

    final nameController = TextEditingController();
    if (item.name.toString() != 'Item Name') nameController.text = item.name;
    final quantityController = TextEditingController();

    if (item.quantity % 1 == 0) {
      quantityController.text = item.quantity.toStringAsFixed(0);
    } else if (item.quantity > 1) {
      quantityController.text = item.quantity.toMixedFraction().toString();
    } else {
      quantityController.text = item.quantity.toFraction().toString();
    }

    if (item.unit.toString() != '') {
      //If the unit selected isnt already blank (in case of newunit creation or  user selected blank and then modified)
      if (type == 'Modify')
        unitController.selected.value = unitController.units.firstWhere((element) => element.name == item.unit);
      else if (type == 'New') unitController.selected.value = unitController.blankUnit;
    }

    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
          child: SizedBox(
            width: 200,
            height: 200,
            child: Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Focus(
                        child: TextFormField(
                          controller: nameController,
                          keyboardType: TextInputType.text,
                          style: TextStyle(color: Get.theme.textTheme.bodyText2!.color),
                          decoration: InputDecoration(
                            hintText: 'Name',
                            hintStyle: TextStyle(color: Get.theme.textTheme.bodyText2!.color),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: _borderRadius,
                              borderSide: BorderSide(color: Get.theme.textTheme.bodyText2!.color!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Get.theme.textTheme.bodyText1!.color!),
                              borderRadius: _borderRadius,
                            ),
                          ),
                        ),
                        onFocusChange: (hasFocus) {
                          if (!hasFocus && type == 'New') {
                            item = item.copyWith(name: nameController.text);
                          }
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: quantityController,
                      // keyboardType: TextInputType.numberWithOptions(decimal: true),
                      style: TextStyle(color: Get.theme.textTheme.bodyText2!.color),
                      decoration: InputDecoration(
                        hintText: 'Quantity',
                        suffixIcon: UnitDropDown(
                          item: item,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: _borderRadius,
                          borderSide: BorderSide(color: Get.theme.textTheme.bodyText2!.color!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Get.theme.textTheme.bodyText1!.color!),
                          borderRadius: _borderRadius,
                        ),
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
                            String input = GetUtils.removeAllWhitespace(nameController.text);
                            if (GetUtils.isNullOrBlank(input)!) {
                              _scaffoldMessengerKey.currentState!
                                  .showSnackBar(SnackBar(content: Text('Item Name cannot be empty')));
                            } else if (!GetUtils.isAlphabetOnly(input)) {
                              _scaffoldMessengerKey.currentState!.showSnackBar(
                                  SnackBar(content: Text('Item Name can only contain alphabetic characters')));
                            } else if (quantityController.text == '') {
                              _scaffoldMessengerKey.currentState!
                                  .showSnackBar(SnackBar(content: Text('Quantity cannot be empty')));
                            } else {
                              Item temp = item.copyWith(
                                name: nameController.text,
                                quantity: controller.getFraction(quantityController.text),
                                unit: unitController.selected.value.name,
                              );
                              Get.back(result: temp);
                            }
                          },
                          icon: Icon(
                            Icons.check_circle,
                            color: Get.theme.textTheme.bodyText2!.color!,
                          ),
                        ),
                        new Spacer(),
                        IconButton(
                          //Cancel
                          onPressed: () {
                            Get.back(result: null);
                          },
                          icon: Icon(
                            Icons.cancel,
                            color: Get.theme.textTheme.bodyText2!.color,
                          ),
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
    );
  }
}
