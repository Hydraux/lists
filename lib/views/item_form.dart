import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/controllers/units_controller.dart';
import 'package:lists/models/item.dart';
import 'package:fraction/fraction.dart';
import 'package:lists/widgets/unit_dropdown.dart';

// ignore: must_be_immutable
class ItemForm extends StatelessWidget {
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  final BorderRadius _borderRadius = BorderRadius.all(Radius.circular(10));

  Item item;
  final String type;

  ItemForm({required this.item, required this.type});

  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    if (item.name.toString() != 'Item Name') nameController.text = item.name;
    final quantityController = TextEditingController();
    quantityController.text = Fraction.fromDouble(item.quantity).toString();
    final UnitsController unitController = Get.put(UnitsController());
    if (item.unit.toString() != '') {
      //If the unit selected isnt already blank (in case of newunit creation or  user selected blank and then modified)
      // if (type == 'Modify')
      //   unitController.selected.value = unitController.unitList.firstWhere((element) => element.name == item.unit);
      // else if (type == 'New') unitController.selected.value = unitController.blankUnit;
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
                          style: TextStyle(color: Theme.of(context).textTheme.bodyText1!.color),
                          decoration: InputDecoration(
                            hintText: 'Name',
                            hintStyle: TextStyle(color: Theme.of(context).textTheme.bodyText1!.color),
                            border: OutlineInputBorder(borderRadius: _borderRadius),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
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
                      keyboardType: TextInputType.numberWithOptions(),
                      style: TextStyle(color: Theme.of(context).textTheme.bodyText1!.color),
                      decoration: InputDecoration(
                        hintText: 'Quantity',
                        suffixIcon: UnitDropDown(
                          item: item,
                        ),
                        border: OutlineInputBorder(borderRadius: _borderRadius),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
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
                                quantity: Fraction.fromString(quantityController.text).toDouble(),
                                //unit: unitController.selected.value.name,
                              );
                              Get.back(result: temp);
                            }
                          },
                          icon: Icon(
                            Icons.check_circle,
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
