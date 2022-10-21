class Unit {
  Unit({
    required this.id,
    required this.index,
    this.name = '',
    required this.favorite,
  });

  final String id;
  final int index;
  final String name;
  final bool favorite;

  Unit copyWith({String? id, int? index, String? name, bool? favorite}) => Unit(
        id: id ?? this.id,
        index: index ?? this.index,
        name: name ?? this.name,
        favorite: favorite ?? this.favorite,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'index': index,
        'name': name,
        'favorite': favorite,
      };

  Unit.fromJson(Map<dynamic, dynamic> json)
      : id = json['id'],
        index = json['index'],
        name = json['name'],
        favorite = json['favorite'];
}
