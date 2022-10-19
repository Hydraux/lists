import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:lists/controllers/auth_controller.dart';
import 'package:lists/models/friend.dart';
import 'package:lists/widgets/friend_form.dart';

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
    DatabaseReference friendsList = database.child(friend.id);
    friendsList.set(friend.toJson());
  }
}
