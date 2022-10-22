import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Recipedia/models/item.dart';

class UnitForm extends StatelessWidget {
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  final BorderRadius _borderRadius = BorderRadius.all(Radius.circular(10));

  final Item? item;

  UnitForm({Key? key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();

    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SimpleDialog(
          shape: RoundedRectangleBorder(borderRadius: _borderRadius),
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: TextFormField(
                controller: nameController,
                keyboardType: TextInputType.text,
                style: TextStyle(color: context.theme.textTheme.bodyText2!.color),
                decoration: InputDecoration(
                  hintText: 'Unit Name',
                  hintStyle: TextStyle(color: context.theme.textTheme.bodyText2!.color),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: _borderRadius,
                      borderSide: BorderSide(color: context.theme.textTheme.bodyText2!.color!)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: context.theme.textTheme.bodyText1!.color!),
                    borderRadius: _borderRadius,
                  ),
                ),
              ),
            ),
            Container(
              height: 30,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      //Validate Item Name
                      if (GetUtils.isLengthGreaterThan(nameController.text, 0)) {
                        Get.back(result: nameController.text);
                      } else {
                        _scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
                          content: Text('Unit name cannot be empty'),
                        ));
                      }
                    },
                    icon: Icon(
                      Icons.check_circle,
                      color: context.theme.textTheme.bodyText2!.color,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(Icons.cancel_rounded),
                    color: context.theme.textTheme.bodyText2!.color,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
