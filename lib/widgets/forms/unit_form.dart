import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/models/item.dart';
import 'package:lists/models/unit.dart';

class UnitForm extends StatelessWidget {
  final Item? item;
  UnitForm({Key? key, this.item}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();

    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.transparent,
        body: Form(
          key: _formKey,
          child: Center(
            child: Card(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                height: 120,
                width: 300,
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                  child: Wrap(
                    direction: Axis.horizontal,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: nameController,
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyText1!.color),
                          decoration: InputDecoration(
                            hintText: 'Unit Name',
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .secondaryHeaderColor)),
                          ),
                        ),
                      ),
                      Container(
                        height: 30,
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                //Validate Item Name
                                if (GetUtils.isLengthGreaterThan(
                                    nameController.text, 0)) {
                                  Unit unit = Unit(
                                      name: nameController.text,
                                      uniqueID: DateTime.now().toString());
                                  Get.back(result: unit);
                                } else {
                                  _scaffoldMessengerKey.currentState!
                                      .showSnackBar(SnackBar(
                                    content: Text('Unit name cannot be empty'),
                                  ));
                                }
                              },
                              icon: Icon(Icons.check_circle),
                            ),
                            IconButton(
                                onPressed: () {
                                  Get.back();
                                },
                                icon: Icon(Icons.cancel_rounded))
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
      ),
    );
  }
}
