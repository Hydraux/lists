import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/models/friend.dart';
import 'package:lists/themes/custom_theme.dart';

class FriendCard extends StatelessWidget {
  final Friend friend;

  FriendCard({required this.friend});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
            child: Text(
          friend.name,
          style: Get.theme.textTheme.bodyText1,
        )),
      ),
    );
  }
}
