import 'package:lists/models/unit.dart';

class Item {
  String name = 'ItemName';
  int? quantity = 1;
  Unit? unit = Unit();
  String? id = 'NewItem';

  Item([name, quantity, unit, id]) {}
}
