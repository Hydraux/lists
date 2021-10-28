import 'dart:io';
import 'package:get/get.dart';
import 'package:lists/models/item.dart';

class Recipe {
  Recipe({
    required this.id,
    required this.name,
    this.ingredients,
    this.steps,
    this.image,
  });

  final RxBool editMode = false.obs;
  final String id;
  final List<Item>? ingredients;
  final List<String>? steps;
  final String name;
  final File? image;

  Recipe copyWith({
    String? id,
    String? name,
    List<Item>? ingredients,
    List<String>? steps,
    File? image,
  }) {
    return Recipe(
      id: id ?? this.id,
      name: name ?? this.name,
      ingredients: ingredients ?? this.ingredients,
      steps: steps ?? this.steps,
      image: image ?? this.image,
    );
  }
}
