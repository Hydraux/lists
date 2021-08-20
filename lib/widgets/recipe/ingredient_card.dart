import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/models/items/item.dart';
import 'package:lists/models/recipes/recipe.dart';
import 'package:lists/views/items/modify_item.dart';

class IngredientCard extends StatelessWidget {
  final int index;
  final Item item;
  final String listType;
  final Recipe recipe;

  IngredientCard({
    required this.item,
    required this.index,
    required this.listType,
    required this.recipe,
  });
  @override
  Widget build(BuildContext context) {
    int itemIndex = recipe.Ingredients.indexOf(item);
    return GestureDetector(
      onTap: () async {
        if (recipe.editMode.value) {
          await Get.to(ModifyItem(item: this.item), opaque: false);
        }
      },
      child: Row(
        children: <Widget>[
          if (recipe.editMode.value)
            IconButton(
              onPressed: () => recipe.controller!
                  .removeIngredient(recipe, recipe.Ingredients[itemIndex]),
              icon: Icon(Icons.delete),
            ),
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(item.name.value.toString(),
                  style: TextStyle(fontSize: 20)),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
                height: 30.0,
                child: Center(
                    child: Obx(
                  () => Text(
                    '${item.quantity}',
                    style: TextStyle(fontSize: 15),
                  ),
                ))),
          ),
        ],
      ),
    );
  }
}