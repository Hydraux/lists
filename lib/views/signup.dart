import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/controllers/auth_controller.dart';

class SignUp extends GetWidget<AuthController> {
  SignUp({Key? key}) : super(key: key);

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.primaryColor,
      resizeToAvoidBottomInset: true,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Sign Up',
              style: TextStyle(
                fontSize: 80,
                color: Colors.white,
              ),
            ),
            SizedBox(
              width: 300,
              child: Form(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: TextFormField(
                          style: TextStyle(color: Colors.white),
                          cursorColor: Colors.white,
                          controller: emailController,
                          decoration: const InputDecoration(
                            filled: true,
                            hintText: 'Email',
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: TextFormField(
                          style: TextStyle(color: Colors.white),
                          cursorColor: Colors.white,
                          controller: passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            filled: true,
                            hintText: 'Password',
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: TextFormField(
                          style: TextStyle(color: Colors.white),
                          cursorColor: Colors.white,
                          controller: confirmPasswordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            filled: true,
                            hintText: 'Confirm Password',
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          if (passwordController.text != confirmPasswordController.text) {
                            Get.snackbar(
                              "Error Signing Up",
                              "Passwords dont match",
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Get.theme.snackBarTheme.backgroundColor,
                              colorText: Get.theme.snackBarTheme.contentTextStyle?.color,
                            );
                          } else if (passwordController.text == '') {
                            Get.snackbar(
                              "Password",
                              "Password field is required",
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Get.theme.snackBarTheme.backgroundColor,
                              colorText: Get.theme.snackBarTheme.contentTextStyle?.color,
                            );
                          } else if (confirmPasswordController.text == '') {
                            Get.snackbar(
                              "Confirm Password",
                              "Confirm Password field is required",
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Get.theme.snackBarTheme.backgroundColor,
                              colorText: Get.theme.snackBarTheme.contentTextStyle?.color,
                            );
                          } else {
                            controller.createUser(emailController.text, passwordController.text);
                          }
                        },
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(fontSize: 20),
                        ),
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(300, 40),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.blue.shade700,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: const Text(
                        'Cancel',
                        style: TextStyle(fontSize: 20),
                      ),
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(300, 40),
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.blue.shade700,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
