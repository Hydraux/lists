import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/controllers/auth_controller.dart';
import 'package:lists/controllers/friends_controller.dart';
import 'package:lists/widgets/friend_card.dart';
import 'package:lists/widgets/friend_form.dart';
import 'package:lists/widgets/username_form.dart';

class Friends extends GetView<FriendsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Friends'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          FriendCard(
            id: "test id",
            name: 'Test name',
          ),
        ],
      ),

      //TODO: implement add friend button
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => controller.addFriend(),
      ),
    );
  }
}
