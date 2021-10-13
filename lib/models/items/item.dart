import 'package:lists/models/unit.dart';

class Item {
  late String name;
  var quantity = 1;
  late Unit unit;
  var uniqueID;

  Item({
    required String name,
    required Unit unit,
  }) {
    if (uniqueID == null) uniqueID = DateTime.now().toString();
    this.name = name;
    this.unit = unit;
  }
}
