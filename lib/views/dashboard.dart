import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/controllers/dashboard_controller.dart';
import 'package:lists/controllers/recipes_controller.dart';
import 'package:lists/controllers/items_controller.dart';
import 'package:lists/views/recipes_page.dart';
import 'package:lists/views/shopping_list.dart';

class DashboardPage extends GetView<DashboardController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => IndexedStack(
            index: controller.selectedIndex.value,
            children: [
              ShoppingList(),
              RecipesPage(),
            ],
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            controller.selectedIndex.value == 0
                ? Get.find<ItemsController>(tag: 'shoppingList').addItem()
                : Get.find<RecipesController>().createRecipe();
          },
          child: Icon(Icons.add)),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: () => controller.onTap(0),
                icon: Icon(
                  Icons.shopping_cart,
                  color: controller.selectedIndex.value == 0
                      ? Theme.of(context).bottomNavigationBarTheme.selectedItemColor
                      : Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
                ),
              ),
              IconButton(
                color: controller.selectedIndex.value == 1
                    ? Theme.of(context).bottomNavigationBarTheme.selectedItemColor
                    : Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
                onPressed: () => controller.onTap(1),
                icon: Icon(Icons.book),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
