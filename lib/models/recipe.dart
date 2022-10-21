import 'package:get/get.dart';

class Recipe {
  Recipe({
    required this.id,
    required this.name,
  });

  final RxBool editMode = false.obs;
  final String id;
  final String name;

  Recipe copyWith({
    String? id,
    String? name,
  }) {
    return Recipe(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  Recipe.fromJson(Map<dynamic, dynamic> json)
      : id = json['id'],
        name = json['name'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}
