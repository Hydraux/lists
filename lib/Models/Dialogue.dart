import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/Models/Items/newItem.dart';
import 'package:lists/controllers/Items/Item.dart';
import 'package:lists/controllers/Recipes/Recipe.dart';

class NewDialogue extends StatelessWidget {
  const NewDialogue({
    required this.textController,
    required this.name,
    required this.type,
  });

  final String name;
  final String type;
  final TextEditingController textController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              color: Theme.of(context).backgroundColor,
            ),
            height: 120,
            width: 300,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              child: Column(
                children: [
                  NewItemField(
                    controller: textController,
                    name: name,
                    autofocus: true,
                  ),
                  Container(
                    height: 30,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            if (type == 'item') {
                              Get.back(
                                  result: ItemController(null)
                                      .makeItem(textController.text));
                            } else if (type == 'recipe') {
                              Get.back(
                                  result: RecipeController()
                                      .makeRecipe(textController.text));
                            } else if (type == 'step') {
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
}
