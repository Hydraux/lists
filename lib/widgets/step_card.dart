import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Recipedia/controllers/auth_controller.dart';
import 'package:Recipedia/controllers/steps_controller.dart';

class StepCard extends StatelessWidget {
  StepCard({required this.step, required this.user}) : super(key: UniqueKey());

  final String step;
  final String user;

  @override
  Widget build(BuildContext context) {
    final AuthController _authController = Get.find<AuthController>();
    final StepsController controller = Get.find<StepsController>();
    return GestureDetector(
      onTap: () async {
        controller.modifyStep(step);
      },
      child: Card(
        color: Get.theme.secondaryHeaderColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        key: UniqueKey(), //Key(item.id),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: user == _authController.user
              ? Dismissible(
                  direction: DismissDirection.endToStart,
                  key: UniqueKey(),
                  onDismissed: (direction) {
                    controller.removeStep(step);
                    Get.snackbar(
                      'Deleted',
                      'step removed from list',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Get.theme.cardColor,
                      mainButton: TextButton.icon(
                          onPressed: (() {
                            controller.steps.add(step);
                            Get.closeCurrentSnackbar();
                          }),
                          icon: Icon(Icons.undo),
                          label: Text('Undo')),
                    );
                  },
                  background: Container(
                    color: Theme.of(Get.context!).errorColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Icon(Icons.delete),
                        ),
                      ],
                    ),
                  ),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        step,
                        style: Get.theme.textTheme.bodyText2,
                      ),
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    step,
                    style: Get.theme.textTheme.bodyText2,
                  ),
                ),
        ),
      ),
    );
  }
}
