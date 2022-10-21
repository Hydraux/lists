import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/models/friend.dart';

class FriendCard extends StatelessWidget {
  final Friend friend;

  FriendCard({required this.friend});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
          child: Text(
        friend.name,
        style: Get.theme.textTheme.bodyText1,
      )),
    );
  }
}
