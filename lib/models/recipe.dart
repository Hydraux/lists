import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/models/item.dart';

class Recipe {
  Recipe({
    required this.id,
    required this.name,
    this.ingredients,
    this.steps,
  });

  final RxBool editMode = false.obs;
  final String id;
  final List<Item>? ingredients;
  final List<String>? steps;
  final String name;

  Recipe copyWith({
    String? id,
    String? name,
    List<Item>? ingredients,
    List<String>? steps,
  }) {
    return Recipe(
      id: id ?? this.id,
      name: name ?? this.name,
      ingredients: ingredients ?? this.ingredients,
      steps: steps ?? this.steps,
    );
  }

  Recipe.fromJson(Map<dynamic, dynamic> json)
      : id = json['id'],
        name = json['name'],
        ingredients = [],
        steps = [];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'steps': steps,
      };
}
