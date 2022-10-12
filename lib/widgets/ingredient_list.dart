import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/controllers/items_controller.dart';
import 'package:lists/models/recipe.dart';

class IngredientList extends StatelessWidget {
  final Recipe recipe;

  const IngredientList({
    required this.recipe,
  });

  @override
  Widget build(BuildContext context) {
    final isc = Get.find<ItemsController>(tag: recipe.id);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() => ReorderableListView(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  onReorder: (oldIndex, newIndex) => isc.reorderList(oldIndex, newIndex),
                  children: isc.itemWidgets)),
              if (recipe.editMode.value)
                Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 2),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          isc.createItem();
                        },
                        child: Icon(Icons.add),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
