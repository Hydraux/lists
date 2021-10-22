import 'package:flutter_test/flutter_test.dart';
import 'package:lists/controllers/dashboard_controller.dart';

void main() {
  test('Given index with value of 1 when onTap() is called then selectedIndex = 1', () async {
    //Arrange
    final DashboardController controller = DashboardController();
    final int index = 1;

    //Act
    controller.selectedIndex(index);

    //Assert
    expect(controller.selectedIndex.value, 1);
  });
}
