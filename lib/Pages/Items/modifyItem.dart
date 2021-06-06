import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/Models/Items/Item.dart';
import 'package:lists/Models/Items/modifyItem.dart';

class ModifyItem extends StatelessWidget {
  final Item item;
  ModifyItem({required this.item});

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
                  ModifyItemField(
                    item: item,
                    controller: item.controller!.itemName!,
                    name: 'Item Name',
                    autofocus: true,
                  ),
                  Container(
                    height: 30,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            item.name.value = item.controller!.itemName!.text;

                            Get.back();
                          },
                          icon: Icon(Icons.check_circle),
                        ),
                        new Spacer(),
                        IconButton(
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
