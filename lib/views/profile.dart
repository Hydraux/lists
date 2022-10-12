import 'package:firebase/firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/controllers/auth_controller.dart';
import 'package:lists/widgets/username_form.dart';

class Profile extends GetView<AuthController> {
  AuthController controller = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Card(
              child: ListTile(
            title: FirebaseAuth.instance.currentUser!.displayName != null
                ? Obx(() {
                    return Text(
                      'Username: ${controller.displayName.value}',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    );
                  })
                : Text(
                    'Username:',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
            subtitle: Text('Tap to edit user name'),
            onTap: () async {
              String id = await Get.dialog(UsernameForm());
              FirebaseAuth.instance.currentUser!.updateDisplayName(id);
            },
          ))
        ],
      ),
    );
  }
}
