import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/controllers/auth_controller.dart';
import 'package:lists/controllers/friends_controller.dart';
import 'package:lists/widgets/friend_card.dart';
import 'package:lists/widgets/friend_form.dart';
import 'package:lists/widgets/item_card.dart';
import 'package:lists/widgets/username_form.dart';

class Friends extends GetView<FriendsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Friends'),
        centerTitle: true,
      ),
      body: Obx(() => ListView.builder(
            itemBuilder: (context, index) => FriendCard(friend: controller.friends[index]),
            itemCount: controller.friends.length,
          )),

      //TODO: implement add friend button
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => controller.addFriend(),
      ),
    );
  }
}
