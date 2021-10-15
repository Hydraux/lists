import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/controllers/units_controller.dart';

class UnitList extends StatelessWidget {
  const UnitList({
    required this.controller,
  });

  final UnitsController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemCount: controller.editableList.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(0),
            child: Dismissible(
              background: Container(
                color: Colors.yellow,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Icon(
                        Icons.star,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              secondaryBackground: Container(
                color: Colors.red,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Icon(
                        Icons.delete,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              key: UniqueKey(),
              confirmDismiss: (direction) async {
                switch (direction) {
                  case DismissDirection.endToStart:
                    return controller.confirmDismiss(
                        controller.editableList[index], Get.context);
                  case DismissDirection.startToEnd:
                    return true;

                  case DismissDirection.vertical:
                  case DismissDirection.horizontal:
                  case DismissDirection.up:
                  case DismissDirection.down:
                  case DismissDirection.none:
                    assert(true);
                }
              },
              onDismissed: (direction) {
                direction == DismissDirection.startToEnd
                    ? controller.favorite(controller.editableList[index])
                    : controller.removeUnit(controller.editableList[index]);
              },
              child: Card(
                margin: EdgeInsets.all(0),
                elevation: 5,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () =>
                          controller.favorite(controller.editableList[index]),
                      icon: Icon(Icons.star_border),
                      color: Colors.white,
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: Text(
                        controller.editableList[index].name,
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
  }
}
