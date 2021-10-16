import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/models/recipe.dart';

class RecipeForm extends StatelessWidget {
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
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2, style: BorderStyle.solid),
                color: Theme.of(context).cardColor,
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
                        style: TextStyle(color: Theme.of(context).textTheme.bodyText1!.color),
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: 'Recipe Name',
                          hintStyle: TextStyle(color: Theme.of(context).textTheme.bodyText1!.color),
                          border: OutlineInputBorder(),
                          focusedBorder:
                              OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).secondaryHeaderColor)),
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
                              if (GetUtils.isLengthGreaterThan(nameController.text, 0)) {
                                Get.back(
                                    result: Recipe(
                                        name: nameController.text,
                                        id: DateTime.now().toString(),
                                        ingredients: [],
                                        steps: []));
                              } else {
                                _scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
                                  content: Text('Recipe name cannot be empty'),
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
    );
  }
}
