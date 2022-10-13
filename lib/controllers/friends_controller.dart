import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:lists/models/friend.dart';
import 'package:lists/widgets/friend_form.dart';

class FriendsController extends GetxController {
  List<Friend> friends = [];

  void addFriend() async {
    String? email = await Get.dialog(FriendForm());

    if (email != null) {}
  }
}
