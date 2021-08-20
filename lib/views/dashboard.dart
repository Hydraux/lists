import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/controllers/dashboard_controller.dart';
import 'package:lists/views/recipes/recipes_page.dart';
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
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart),
                label: 'Shopping List',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.book),
                label: 'Recipes',
              ),
            ],
            currentIndex: controller.selectedIndex.value,
            onTap: controller.onTap,
          )),
    );
  }
}