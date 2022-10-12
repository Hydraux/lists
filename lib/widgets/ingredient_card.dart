import 'package:flutter/material.dart';
import 'package:fraction/fraction.dart';
import 'package:get/get.dart';
import 'package:lists/controllers/items_controller.dart';
import 'package:lists/controllers/settings_controller.dart';
import 'package:lists/models/item.dart';
import 'package:lists/models/recipe.dart';
import 'package:lists/themes/custom_theme.dart';
import 'package:lists/views/item_form.dart';

class IngredientCard extends StatelessWidget {
  final int index;
  final Item item;
  final Recipe recipe;

  IngredientCard({
    required this.item,
    required this.index,
    required this.recipe,
  });
  @override
  Widget build(BuildContext context) {
    final SettingsController settings = Get.find<SettingsController>();
    final ItemsController isc = Get.find<ItemsController>(tag: recipe.id);
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
          color: context.theme.secondaryHeaderColor,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Row(
          children: <Widget>[
            if (recipe.editMode.value)
              IconButton(
                onPressed: () {} /*isc.removeItem(index)*/,
                icon: Icon(Icons.delete),
              ),
            Checkbox(
                value: item.checkBox,
                onChanged: (value) {
                  value! == true ? isc.uncheck(item) : isc.check(item);
                  Item temp = item.copyWith(checkBox: value);
                  isc.uploadItem(temp);
                }),
            Expanded(
                flex: 6,
                child: Text(
                  item.name,
                  style: TextStyle(fontSize: 20),
                )),
            Expanded(
              flex: 0,
              child: Container(
                  height: 30.0,
                  child: Center(child: Obx(() {
                    Fraction frac = Fraction.fromDouble(item.quantity);
                    MixedFraction quantity = MixedFraction.fromFraction(frac);
                    return Text(
                      '$quantity ${item.unit}',
                      style: TextStyle(
                          fontSize: 20,
                          color: settings.darkMode.value ? darkTheme.textTheme.bodyText2!.color : Colors.white),
                    );
                  }))),
            ),
          ],
        ),
      ),
    );
  }
}
