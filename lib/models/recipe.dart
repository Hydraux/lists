import 'package:Recipedia/models/item.dart';
import 'package:get/get.dart';

class Recipe {
  Recipe({
    required this.id,
    required this.name,
    required this.cookTime,
    required this.prepTime,
    required this.servings,
    required this.ingredients,
    required this.steps,
    required this.notes,
    required this.rating,
  });

  final RxBool editMode = false.obs;
  final String id;
  final String name;
  final String cookTime;
  final String prepTime;
  final int servings;
  final List<Item> ingredients;
  final List<String> steps;
  final String notes;
  final int rating;

  Recipe copyWith({
    String? id,
    String? name,
    String? cookTime,
    String? prepTime,
    int? servings,
    List<Item>? ingredients,
    List<String>? steps,
    String? notes,
    int? rating,
  }) {
    return Recipe(
      id: id ?? this.id,
      name: name ?? this.name,
      cookTime: cookTime ?? this.cookTime,
      servings: servings ?? this.servings,
      prepTime: prepTime ?? this.prepTime,
      ingredients: ingredients ?? this.ingredients,
      steps: steps ?? this.steps,
      notes: notes ?? this.notes,
      rating: rating ?? this.rating,
    );
  }

  Recipe.fromJson(Map<dynamic, dynamic> json)
      : id = json['id'],
        name = json['name'],
        cookTime = json['cookTime'] ?? '1',
        servings = json['servings'] ?? 1,
        prepTime = json['prepTime'] ?? '1',
        ingredients = getIngredients(json['ingredients']),
        steps = getSteps(json['steps']),
        notes = json['notes'] ?? '',
        rating = json['rating'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'cookTime': cookTime,
        'prepTime': prepTime,
        'servings': servings,
        'ingredients': ingredientsToJson(ingredients),
        'steps': steps,
        'notes': notes,
        'rating': rating,
      };

  static List<Item> getIngredients(Map? JsonIngredients) {
    List<Item> ingredients = [];
    if (JsonIngredients != null)
      JsonIngredients.forEach((key, value) {
        Item item = Item.fromJson(value);
        ingredients.add(item);
      });
    return ingredients;
  }

  static getSteps(List? JsonSteps) {
    List<String> steps = [];
    if (JsonSteps != null) {
      JsonSteps.forEach((value) {
        String step = value;
        steps.add(step);
      });
    }

    return steps;
  }

  static Map ingredientsToJson(List<Item> ingredients) {
    Map JsonIngredients = {};
    ingredients.forEach((Item item) {
      Map JsonItem = item.toJson();
      JsonIngredients[item.id] = JsonItem;
    });
    return JsonIngredients;
  }
}
