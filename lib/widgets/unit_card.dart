import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Recipedia/controllers/units_controller.dart';
import 'package:Recipedia/models/unit.dart';

class UnitCard extends StatelessWidget {
  final UnitsController controller;
  final Unit unit;

  UnitCard({required this.unit, required this.controller});

  Widget build(context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      key: UniqueKey(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.endToStart,
            confirmDismiss: (direction) async {
              return controller.confirmDismiss(unit.name);
            },
            onDismissed: (direction) {
              controller.removeUnit(unit.id);
              Get.snackbar(
                'Deleted',
                '${unit.name} removed from list',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Get.theme.cardColor,
                mainButton: TextButton.icon(
                    onPressed: (() {
                      controller.uploadUnit(unit);
                      Get.closeCurrentSnackbar();
                    }),
                    icon: Icon(Icons.undo),
                    label: Text('Undo')),
              );
            },
            background: Container(
              color: Get.theme.errorColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Icon(
                      Icons.delete,
                    ),
                  ),
                ],
              ),
            ),
            child: Stack(
              alignment: AlignmentDirectional.centerStart,
              children: [
                IconButton(
                  onPressed: () {
                    controller.toggleFavorite(unit);
                  },
                  icon: Icon(
                    Icons.star,
                    color: unit.favorite ? Colors.yellow : Colors.white,
                  ),
                ),
                Center(
                    child: Text(
                  unit.name,
                  style: Get.theme.textTheme.bodyText1,
                ))
              ],
            )),
      ),
    );
  }
}
