import 'package:get/get.dart';
import 'package:lists/models/item.dart';

class Recipe {
  Recipe({
    required this.id,
    required this.name,
  });

  final RxBool editMode = false.obs;
  final String id;

  //TODO: Check if observable children update parent
  final RxList<Item> ingredients = RxList<Item>([]);
  final RxList<String> steps = RxList<String>([]);
  final String name;
}
