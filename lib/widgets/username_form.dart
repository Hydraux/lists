import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UsernameForm extends GetWidget {
  TextEditingController nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: SimpleDialog(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: TextFormField(
              controller: nameController,
              style: TextStyle(color: Get.theme.textTheme.bodyText1!.color),
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: 'Username',
                hintStyle: TextStyle(color: Get.theme.textTheme.bodyText1!.color),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),
          Container(
              height: 30,
              child: Row(children: [
                IconButton(
                  onPressed: () {
                    //Validate Item Name
                    if (GetUtils.isLengthGreaterThan(nameController.text, 0)) {
                      Get.back(result: nameController.text);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Username cannot be empty'),
                      ));
                    }
                  },
                  icon: Icon(Icons.check_circle),
                ),
                Spacer(),
                IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(Icons.cancel_rounded))
              ]))
        ]));
  }
}