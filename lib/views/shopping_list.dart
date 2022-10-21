import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lists/controllers/items_controller.dart';
import 'package:lists/themes/proxy_decorator.dart';

class ShoppingList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ItemsController>(tag: 'shoppingList');
    return Obx(
      () => ListView(children: [
        AppBar(
          centerTitle: true,
          title: Text('Shopping List'),
        ),
        ReorderableListView(
          onReorderStart: ((index) => HapticFeedback.heavyImpact()),
          physics: NeverScrollableScrollPhysics(),
          proxyDecorator: proxyDecorator,
          shrinkWrap: true,
          onReorder: (oldIndex, newIndex) => controller.reorderList(oldIndex, newIndex, controller.items),
          children: controller.getListItems(controller.items, true),
        ),
        if (controller.checkList.length > 0)
          Divider(
            color: Get.theme.primaryColor,
            thickness: 2,
          ),
        Expanded(
          child: ListView(
            physics: NeverScrollableScrollPhysics(),
            children: controller.checkList.length > 0 ? controller.getListItems(controller.checkList, true) : [],
          ),
        ),
      ]),
    );
  }
}
