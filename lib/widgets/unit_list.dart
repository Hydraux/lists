import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/controllers/items/units_controller.dart';

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
              direction: DismissDirection.startToEnd,
              background: Container(
                color: Colors.red,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
              key: UniqueKey(),
              confirmDismiss: (direction) => controller.confirmDismiss(
                  controller.editableList[index], context),
              onDismissed: (direction) {
                controller.removeUnit(controller.editableList[index]);
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
