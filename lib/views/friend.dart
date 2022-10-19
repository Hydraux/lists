import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:lists/controllers/recipes_controller.dart';
import 'package:lists/models/friend.dart';
import 'package:lists/widgets/recipe_card.dart';

class FriendPage extends StatelessWidget {
  final Friend friend;

  FriendPage({required this.friend});

  @override
  Widget build(BuildContext context) {
    RecipesController controller = Get.find<RecipesController>(tag: friend.id);
    return Scaffold(
      appBar: AppBar(
        title: Text(friend.name),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Center(
                  child: Text("Info", style: Get.theme.textTheme.bodyLarge),
                ),
                Divider(
                  color: Get.theme.backgroundColor,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    "Email: " + friend.email,
                    style: Get.theme.textTheme.bodySmall,
                    textAlign: TextAlign.left,
                  ),
                ),
                Text("")
              ]),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                      child: Text(
                    "Recipes",
                    style: Get.theme.textTheme.bodyLarge,
                  )),
                  Divider(
                    color: Get.theme.backgroundColor,
                  ),
                  Obx(
                    () => ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (context, index) => RecipeCard(
                        recipe: controller.recipes[index],
                        local: false,
                        user: controller.user,
                      ),
                      itemCount: controller.recipes.length,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
