import 'package:flutter/material.dart';
import 'package:fraction/fraction.dart';
import 'package:get/get.dart';
import 'package:lists/controllers/items_controller.dart';
import 'package:lists/models/item.dart';
import 'package:lists/widgets/item_card.dart';

class IngredientCard extends StatelessWidget {
  final Item item;
  final ItemsController isc;
  final bool local;

  IngredientCard({required this.item, required this.isc, required this.local}) : super(key: UniqueKey());
  @override
  Widget build(BuildContext context) {
    return getCard();
  }

  Widget _getChild(Item item) {
    {
      String quantity = item.quantity.toStringAsFixed(0);
      if (item.quantity % 1 != 0) {
        quantity = item.quantity.toMixedFraction().toString();
      }
      return Text(
        '$quantity ${item.unit}',
        style: Get.theme.textTheme.bodyText1,
      );
    }
  }

  Widget getCard() {
    if (local) {
      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        color: item.checkBox ? Colors.grey : Get.theme.secondaryHeaderColor,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Dismissible(
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              isc.removeItem(item.id, isc.databaseItems);
              Get.snackbar(
                'Deleted',
                '${item.name} removed from list',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Get.theme.cardColor,
                mainButton: TextButton.icon(
                    onPressed: (() {
                      isc.uploadItem(item);
                      Get.closeCurrentSnackbar();
                    }),
                    icon: Icon(Icons.undo),
                    label: Text('Undo')),
              );
            },
            key: UniqueKey(),
            background: Container(
              color: Theme.of(Get.context!).errorColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Icon(Icons.delete),
                  ),
                ],
              ),
            ),
            child: GestureDetector(
              onTap: () => isc.modifyItem(item),
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Row(
                  children: <Widget>[
                    Checkbox(
                        checkColor: Get.theme.cardColor,
                        activeColor: Colors.white,
                        value: item.checkBox,
                        onChanged: (value) {
                          value! == true ? isc.check(item) : isc.uncheck(item);
                        }),
                    Expanded(flex: 6, child: Text(item.name, style: Get.theme.textTheme.bodyText1)),
                    Expanded(flex: 0, child: _getChild(item)),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      return ItemCard(item: item, controller: isc);
    }
  }
}
