import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/controllers/friends_controller.dart';

class Friends extends GetView<FriendsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Friends'),
        centerTitle: true,
      ),
      body: Obx(() => ListView.builder(
            itemBuilder: (context, index) => controller.getFriends(index),
            itemCount: controller.friends.length,
          )),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => controller.addFriend(),
      ),
    );
  }
}
