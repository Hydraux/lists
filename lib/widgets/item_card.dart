import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/controllers/items_controller.dart';
import '../models/item.dart';

class ItemCard extends StatelessWidget {
  final ItemsController isc = Get.find();
  final int index;
  final Item item;

  ItemCard({
    required this.item,
    required this.index,
    required bool editMode,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Get.toNamed('/ModifyItem', arguments: item);
        isc.updateValue(index);
      },
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 6,
            child: Padding(padding: const EdgeInsets.all(8.0), child: Text(item.name, style: TextStyle(fontSize: 20))),
          ),
          Expanded(
            flex: 0,
            child: Container(
                height: 30.0,
                child: Center(
                  child: Text(
                    '${item.quantity} ${item.unit}',
                    style: TextStyle(fontSize: 20),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}