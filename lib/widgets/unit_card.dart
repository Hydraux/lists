import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/controllers/units_controller.dart';
import 'package:lists/models/unit.dart';

class UnitCard extends StatelessWidget {
  UnitsController controller;
  Unit unit;

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
              controller.confirmDismiss(unit.name);
            },
            onDismissed: (direction) {
              controller.removeUnit(unit.id);
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
