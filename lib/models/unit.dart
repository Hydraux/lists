class Unit {
  Unit({
    required this.id,
    required this.index,
    this.name = '',
  });

  final String id;
  final int index;
  final String name;

  Unit copyWith({String? id, int? index, String? name}) => Unit(
        id: id ?? this.id,
        index: index ?? this.index,
        name: name ?? this.name,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'index': index,
        'name': name,
      };

  Unit.fromJson(Map<dynamic, dynamic> json)
      : id = json['id'],
        index = json['index'],
        name = json['name'];
}
