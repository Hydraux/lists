import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/Pages/Recipes/Recipes.dart';
import 'package:lists/Pages/shoppingList.dart';
import 'package:lists/controllers/Dashboard.dart';

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
