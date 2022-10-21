import 'package:flutter/material.dart';
import 'package:fraction/fraction.dart';
import 'package:get/get.dart';
import 'package:lists/controllers/items_controller.dart';
import 'package:lists/controllers/settings_controller.dart';
import '../models/item.dart';

class ItemCard extends StatelessWidget {
  final Item item;
  final SettingsController settings = Get.find<SettingsController>();
  final ItemsController controller;

  ItemCard({
    required this.item,
    required this.controller,
  }) : super(key: UniqueKey());

  @override
  Widget build(BuildContext context) {
    return Card(
      color: controller.getCardColor(item),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      key: UniqueKey(), //Key(item.id),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: controller.user == controller.authController.user
              ? Dismissible(
                  key: UniqueKey(),
                  onDismissed: (direction) {
                    if (direction == DismissDirection.endToStart) {
                      controller.removeItem(item.id, controller.databaseItems);
                      Get.snackbar(
                        'Deleted',
                        '${item.name} removed from list',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Get.theme.cardColor,
                        mainButton: TextButton.icon(
                            onPressed: (() {
                              controller.uploadItem(item);
                              Get.closeCurrentSnackbar();
                            }),
                            icon: Icon(Icons.undo),
                            label: Text('Undo')),
                      );
                    } else if (direction == DismissDirection.startToEnd)
                      item.checkBox ? controller.uncheck(item) : controller.check(item);
                  },
                  secondaryBackground: Container(
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
                  background: Container(
                    color: item.checkBox ? Color.fromARGB(255, 73, 83, 73) : Colors.green,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: item.checkBox ? Icon(Icons.check_box_outline_blank) : Icon(Icons.check),
                        ),
                      ],
                    ),
                  ),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: GestureDetector(
                        onTap: () async {
                          controller.modifyItem(item);
                        },
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      item.name,
                                      style: TextStyle(
                                          decoration: item.checkBox ? TextDecoration.lineThrough : null,
                                          fontSize: 20,
                                          color:
                                              item.checkBox ? Colors.grey[800] : Get.theme.textTheme.bodyText1!.color),
                                    ))),
                            Expanded(
                              flex: 0,
                              child: Container(height: 30.0, child: Center(child: _getChild(item))),
                            ),
                          ],
                        )),
                  ),
                )
              : Row(
                  children: <Widget>[
                    Expanded(
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              item.name,
                              style: TextStyle(
                                  decoration: item.checkBox ? TextDecoration.lineThrough : null,
                                  fontSize: 20,
                                  color: item.checkBox ? Colors.grey[800] : Get.theme.textTheme.bodyText1!.color),
                            ))),
                    Expanded(
                      flex: 0,
                      child: Container(height: 30.0, child: Center(child: _getChild(item))),
                    ),
                  ],
                )),
    );
  }

  Widget? _getChild(Item item) {
    {
      if (item.quantity != null) {
        String quantity = item.quantity!.toStringAsFixed(0);
        if (item.quantity! % 1 != 0) {
          quantity = item.quantity!.toMixedFraction().toString();
        }
        return Text(
          '$quantity ${item.unit}',
          style:
              TextStyle(fontSize: 20, color: item.checkBox ? Colors.grey[800] : Get.theme.textTheme.bodyText1!.color),
        );
      } else {
        return null;
      }
    }
  }
}
