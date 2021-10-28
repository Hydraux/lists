import 'package:flutter/material.dart';
import 'package:fraction/fraction.dart';
import '../models/item.dart';

import 'package:intl/intl.dart';

class ItemCard extends StatelessWidget {
  final int index;
  final Item item;

  ItemCard({
    required this.item,
    required this.index,
    required bool editMode,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
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
                  '${Fraction.fromDouble(item.quantity)} ${item.unit}',
                  style: TextStyle(fontSize: 20),
                ),
              )),
        ),
      ],
    );
  }
}
