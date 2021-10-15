import 'package:lists/models/unit.dart';

class Item {
  Item({
    required this.id,
    this.name = '',
    this.quantity = 1,
    this.unit = '',
  });

  String id;
  String name;
  int quantity;
  String unit;
}
