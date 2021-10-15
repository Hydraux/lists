import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListReorderable extends StatelessWidget {
  final parentObject;

  ListReorderable({required this.parentObject});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return ReorderableListView(
        onReorder: parentObject.controller.reorderList,
        children: parentObject.controller.getListItems(),
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
      );
    });
  }
}
