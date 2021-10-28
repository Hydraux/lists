import 'package:flutter/material.dart';
import 'package:fraction/fraction.dart';
import 'package:get/get.dart';
import 'package:lists/controllers/items_controller.dart';
import 'package:lists/models/item.dart';
import 'package:lists/models/recipe.dart';
import 'package:lists/views/item_form.dart';
import 'package:intl/intl.dart';

class IngredientCard extends StatelessWidget {
  final int index;
  final Item item;
  final Recipe recipe;

  final ItemsController isc = Get.find<ItemsController>(tag: 'Ingredients');

  IngredientCard({
    required this.item,
    required this.index,
    required this.recipe,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (recipe.editMode.value) {
          await Get.to(() => ItemForm(item: item, type: 'Modify'));
        }
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
        margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
        decoration: BoxDecoration(
          color: Theme.of(context).secondaryHeaderColor,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Row(
          children: <Widget>[
            if (recipe.editMode.value)
              IconButton(
                onPressed: () => isc.removeItem(index),
                icon: Icon(Icons.delete),
              ),
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(item.name, style: TextStyle(fontSize: 20)),
              ),
            ),
            Expanded(
              flex: 0,
              child: Container(
                  height: 30.0,
                  child: Center(
                    child: Text(
                      '${Fraction.fromDouble(item.quantity)} ' '${item.unit}',
                      style: TextStyle(fontSize: 15),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
