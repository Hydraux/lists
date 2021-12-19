import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StepForm extends StatelessWidget {
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  final BorderRadius _borderRadius = BorderRadius.all(Radius.circular(10));

  final String? step;
  final int? index;
  StepForm({this.step, this.index});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    if (step != null) {
      nameController.text = step!;
    }

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
                  style: TextStyle(color: Get.theme.textTheme.bodyText1!.color),
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: 'Step Instructions',
                    hintStyle: TextStyle(color: Get.theme.textTheme.bodyText1!.color),
                    border: OutlineInputBorder(borderRadius: _borderRadius),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
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
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Step cannot be empty'),
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
                  ],
                ),
              )
            ],
          )),
    );
  }
}
