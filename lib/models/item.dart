class Item {
  Item({
    required this.id,
    required this.index,
    this.name = '',
    this.quantity = 1,
    this.unit = '',
    this.checkBox = false,
  });

  final String id;
  final int index;
  final String name;
  final double quantity;
  final String unit;
  final bool checkBox;

  Item copyWith({String? id, int? index, String? name, double? quantity, String? unit, bool? checkBox}) {
    return Item(
        id: id ?? this.id,
        index: index ?? this.index,
        name: name ?? this.name,
        quantity: quantity ?? this.quantity,
        unit: unit ?? this.unit,
        checkBox: checkBox ?? this.checkBox);
  }

  Item.fromJson(Map<dynamic, dynamic> json)
      : id = json['id'],
        index = json['index'],
        name = json['name'],
        quantity =
            json['quantity'].toDouble(), // toDouble() is necessary because firebase stores 1.0 as 1 which is an int
        unit = json['unit'],
        checkBox = json['checkBox'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'index': index,
        'name': name,
        'quantity': quantity,
        'unit': unit,
        'checkBox': checkBox,
      };
}
