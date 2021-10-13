import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavoritesList extends StatelessWidget {
  final listController;

  FavoritesList({required this.listController});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return ReorderableListView(
        onReorder: listController.reorderList,
        children: listController.getListItems(),
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
      );
    });
  }
}
