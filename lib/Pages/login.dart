import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/Pages/shopping_list.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  final Email = TextEditingController();

  final Password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Sign In',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 30),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                      color: Colors.blueGrey[800],
                      boxShadow: [
                        BoxShadow(
                          spreadRadius: 0,
                          blurRadius: 7,
                        ),
                      ]),
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: TextField(
                        controller: Email,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Email',
                          suffixIcon: Icon(Icons.email),
                        )),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                      color: Colors.blueGrey[800],
                      boxShadow: [
                        BoxShadow(
                          spreadRadius: 0,
                          blurRadius: 7,
                        ),
                      ]),
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: TextField(
                        controller: Password,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Password',
                          suffixIcon: Icon(Icons.lock),

                          //fillColor: Colors.white,
                          // border: OutlineInputBorder(),
                        )),
                  ),
                ),
              ),
              Container(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(spreadRadius: 1, blurRadius: 3)
                          ]),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            //side: BorderSide(color: Colors.black, width: 1),
                            primary: Colors.blueGrey[800],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () async {
                            try {
                              UserCredential userCredential =
                                  await firebaseAuth.signInWithEmailAndPassword(
                                      email: Email.text,
                                      password: Password.text);
                              Get.to(ShoppingList());
                            } catch (e) {
                              final snackBar =
                                  SnackBar(content: Text(e.toString()));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                              setState(() {});
                            }
                          },
                          child: Text('Sign In')),
                    ),
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
