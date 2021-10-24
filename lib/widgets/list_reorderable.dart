import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ListReorderable extends StatelessWidget {
  final controller;

  ListReorderable({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GestureDetector(
        onLongPress: () => HapticFeedback.vibrate(),
        child: ReorderableListView(
          onReorder: controller.reorderList,
          children: controller.getListItems(),
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
        ),
      ),
    );
  }
}
