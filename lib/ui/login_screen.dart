import 'package:flutter/material.dart';
import 'package:mobilefinal2/ui/home_screen.dart';
import 'package:mobilefinal2/util/state.dart';
import 'package:toast/toast.dart';
import 'package:mobilefinal2/util/user_account.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formkey = GlobalKey<FormState>();
  final user_check = TextEditingController();
  final password_check = TextEditingController();

  UserProvider user = UserProvider();

  bool isValid = false;
  int formState = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 30, 30, 0),
        child: ListView(
          children: <Widget>[
            Center(
                child: Image.asset(
              'assets/pic1.jpg',
              width: 250,
            )),
            Form(
              key: _formkey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: user_check,
                    decoration: InputDecoration(
                      labelText: "User Id",
                      prefixIcon: Icon(Icons.person),
                    ),
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value.isNotEmpty) {
                        this.formState += 1;
                      }
                    },
                  ),
                  TextFormField(
                    controller: password_check,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password",
                      prefixIcon: Icon(Icons.lock),
                    ),
                    validator: (value) {
                      if (value.isNotEmpty) {
                        this.formState += 1;
                      }
                    },
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                          child: RaisedButton(
                              child: Text("LOGIN"),
                              onPressed: () async {
                                _formkey.currentState.validate();

                                await user.open("user.db");
                                Future<List<User>> allUser = user.getAllUser();

                                Future isUserValid(String userid, String password) async {
                                  var userList = await allUser;
                                  print(userList);
                                  for (var i = 0; i < userList.length; i++) {
                                    if (userid == userList[i].userid &&
                                        password == userList[i].password) {
                                      CurrentUser.ID = userList[i].id;
                                      CurrentUser.USERID = userList[i].userid;
                                      CurrentUser.NAME = userList[i].name;
                                      CurrentUser.AGE = userList[i].age;
                                      CurrentUser.PASSWORD = userList[i].password;
                                      CurrentUser.QUOTE = userList[i].quote;
                                      this.isValid = true;
                                      print("this user valid");
                                      break;
                                    }
                                  }
                                }

                                if (this.formState != 2) {
                                  Toast.show(
                                      "Please fill out this form", context,
                                      duration: Toast.LENGTH_SHORT,
                                      gravity: Toast.BOTTOM);
                                  this.formState = 0;
                                  print('empty form');
                                } else {
                                  print(' form not empty');
                                  this.formState = 0;
                                  print("${user_check.text}, ${password_check.text}");
                                  await isUserValid(user_check.text, password_check.text);
                                  if (!this.isValid) {
                                    print('user not valid');
                                    Toast.show(
                                        "Invalid user or password", context,
                                        duration: Toast.LENGTH_SHORT,
                                        gravity: Toast.BOTTOM);
                                  } else {
                                    print('already login');
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => HomePageScreen()));
                                    user_check.text = "";
                                    password_check.text = "";
                                  }
                                }
                              }),
                        ),
                      ),
                    ],
                  ),
                  FlatButton(
                      child: Text(
                        "Register New Account",
                      ),
                      padding: EdgeInsets.only(left: 160.0),
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed('register');
                      }),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
