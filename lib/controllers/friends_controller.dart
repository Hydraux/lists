import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Recipedia/controllers/auth_controller.dart';
import 'package:Recipedia/controllers/recipes_controller.dart';
import 'package:Recipedia/models/friend.dart';
import 'package:Recipedia/views/friend.dart';
import 'package:Recipedia/widgets/friend_card.dart';
import 'package:Recipedia/widgets/friend_form.dart';

class FriendsController extends GetxController {
  late DatabaseReference database;
  AuthController authController = Get.find<AuthController>();
  RxList<Friend> friends = RxList();

  @override
  void onInit() {
    database = FirebaseDatabase.instance.ref('${authController.user}/friends');
    _activateListeners();
    super.onInit();
  }

  Future<Friend> _checkForUpdates(Friend friend) async {
    await authController.users.doc(friend.email).get().then((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        Friend firestoreRecord = Friend.fromJson(snapshot.data() as Map);
        if (firestoreRecord.name != friend.name) {
          Friend newFriend = friend.copyWith(name: firestoreRecord.name);
          uploadFriend(newFriend);
          friend = newFriend;
        }
      }
    });
    return friend;
  }

  void _activateListeners() {
    database.onChildAdded.listen((event) async {
      Friend friend = Friend.fromJson(event.snapshot.value as Map);

      friend = await _checkForUpdates(friend);
      friends.add(friend);
    });
  }

  void addFriend() async {
    String? email = await Get.dialog(FriendForm());

    if (email != null) {
      authController.users.doc(email).get().then((DocumentSnapshot snapshot) {
        if (snapshot.exists) {
          Friend friend = Friend.fromJson(snapshot.data() as Map);
          uploadFriend(friend);
        } else {
          Get.snackbar(
            'User not found',
            'There is no account with this email',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Get.theme.primaryColor,
          );
        }
      });
    }
  }

  void uploadFriend(Friend friend) {
    DatabaseReference databaseFriend = database.child(friend.id);
    databaseFriend.set(friend.toJson());
  }

  Widget getFriends(int index) {
    return GestureDetector(
      onTap: (() {
        Get.lazyPut(() => RecipesController(user: friends[index].id), tag: friends[index].id);
        Get.to(() => FriendPage(
              friend: friends[index],
            ));
      }),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(7),
          child: Dismissible(
            direction: DismissDirection.endToStart,
            onDismissed: (direction) => removeFriend(index),
            key: UniqueKey(),
            background: Container(
              color: Theme.of(Get.context!).errorColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Icon(Icons.delete),
                  ),
                ],
              ),
            ),
            child: FriendCard(friend: friends[index]),
          ),
        ),
      ),
    );
  }

  removeFriend(int index) {
    Friend friend = friends[index];
    DatabaseReference databaseFriend = database.child(friend.id);
    databaseFriend.remove();
    friends.remove(friend);
  }
}
