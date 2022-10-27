import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:Recipedia/models/recipe.dart';

class RecipeForm extends StatelessWidget {
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  final BorderRadius _borderRadius = BorderRadius.all(Radius.circular(10));

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final servingsController = TextEditingController();
    final prepTimeController = TextEditingController();
    final cookTimeController = TextEditingController();

    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SimpleDialog(
          shape: RoundedRectangleBorder(borderRadius: _borderRadius),
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8),
              child: TextFormField(
                controller: nameController,
                style: TextStyle(color: context.theme.textTheme.bodyText1!.color),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: 'Recipe Name',
                  hintStyle: TextStyle(color: context.theme.textTheme.bodyText1!.color),
                  border: OutlineInputBorder(borderRadius: _borderRadius),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: _borderRadius,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8),
              child: TextFormField(
                controller: servingsController,
                style: TextStyle(color: context.theme.textTheme.bodyText1!.color),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  hintText: 'Servings',
                  hintStyle: TextStyle(color: context.theme.textTheme.bodyText1!.color),
                  border: OutlineInputBorder(borderRadius: _borderRadius),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: _borderRadius,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8),
              child: TextFormField(
                controller: prepTimeController,
                style: TextStyle(color: context.theme.textTheme.bodyText1!.color),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  hintText: 'Prep Time',
                  hintStyle: TextStyle(color: context.theme.textTheme.bodyText1!.color),
                  border: OutlineInputBorder(borderRadius: _borderRadius),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: _borderRadius,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8),
              child: TextFormField(
                controller: cookTimeController,
                style: TextStyle(color: context.theme.textTheme.bodyText1!.color),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  hintText: 'Cook Time',
                  hintStyle: TextStyle(color: context.theme.textTheme.bodyText1!.color),
                  border: OutlineInputBorder(borderRadius: _borderRadius),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: _borderRadius,
                  ),
                ),
              ),
            ),
            Container(
              height: 22,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      //Validate Item Name
                      if (GetUtils.isLengthGreaterThan(nameController.text, 0)) {
                        //Get Date
                        String date = DateTime.now().toString();

                        //Extract numbers
                        double dateNumbers = double.parse(date.replaceAll(RegExp('[^0-9]'), ''));

                        //Convert to string and remove decimal place
                        String dateID = dateNumbers.toStringAsFixed(0);
                        Get.back(
                            result: Recipe(
                          name: nameController.text,
                          servings: int.parse(servingsController.text),
                          cookTime: cookTimeController.text,
                          prepTime: prepTimeController.text,
                          ingredients: [],
                          steps: [],
                          id: dateID,
                        ));
                      } else {
                        _scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
                          content: Text('Recipe name cannot be empty'),
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
        ),
      ),
    );
  }
}
