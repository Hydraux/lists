import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/themes/custom_theme.dart';

class FriendCard extends StatelessWidget {
  final String id;
  final String name;

  FriendCard({required this.id, required this.name});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
            child: Text(
          name,
          style: Get.theme.textTheme.bodyText1,
        )),
      ),
    );
  }
}
