import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/controllers/recipes_controller.dart';
import 'package:lists/models/friend.dart';
import 'package:lists/themes/custom_theme.dart';
import 'package:lists/views/friend.dart';

class FriendCard extends StatelessWidget {
  final Friend friend;

  FriendCard({required this.friend});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
              child: Text(
            friend.name,
            style: Get.theme.textTheme.bodyText1,
          )),
        ),
      ),
      onTap: (() {
        Get.lazyPut(() => RecipesController(user: friend.id), tag: friend.id);
        Get.to(() => FriendPage(
              friend: friend,
            ));
      }),
    );
  }
}
