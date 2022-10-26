import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:Recipedia/controllers/items_controller.dart';
import 'package:Recipedia/themes/proxy_decorator.dart';

class ShoppingList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ItemsController>(tag: 'shoppingList');
    return Obx(
      () => Column(children: [
        AppBar(
          centerTitle: true,
          title: Text('Shopping List'),
        ),
        Expanded(
          child: ListView(shrinkWrap: true, children: [
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
            if (controller.checkList.length > 0)
              ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: controller.checkList.length > 0 ? controller.getListItems(controller.checkList, true) : [],
              ),
          ]),
        ),
      ]),
    );
  }
}
