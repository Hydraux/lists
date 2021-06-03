import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/Models/newItem.dart';
import 'package:lists/controllers/Item.dart';

class NewItem extends GetView<ItemController> {
  final TextEditingController textController = TextEditingController();
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
                    name: 'New Item',
                    autofocus: true,
                  ),
                  Container(
                    height: 30,
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              Get.back(
                                  result: ItemController()
                                      .makeItem(textController.text));
                              Get.back();
                            },
                            icon: Icon(Icons.check_circle)),
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
