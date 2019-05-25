import 'package:flutter/material.dart';
import 'package:mobilefinal2/util/user_account.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formkey = GlobalKey<FormState>();
  UserProvider user = UserProvider();
  final userid = TextEditingController();
  final name = TextEditingController();
  final age = TextEditingController();
  final password = TextEditingController();
  final repassword = TextEditingController();
  final quote = TextEditingController();

  int isSpace(String s) {
    int result = 0;
    for (int i = 0; i < s.length; i++) {
      if (s[i] == ' ') {
        result += 1;
      }
    }
    return result;
  }

  bool isUserIn = false;

  bool isAgeTrue(String s) {
    if (s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(30),
            child: Form(
              key: _formkey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                      controller: userid,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        labelText: "User Id",
                        hintText: "User Id must be between 6 to 12",
                      ),
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please fill out this form";
                        } else if (value.length < 6 || value.length > 12) {
                          return "Please fill UserId Correctly";
                        } else if (this.isUserIn) {
                          return "This Username is taken";
                        }
                      }),
                  TextFormField(
                      decoration: InputDecoration(
                        labelText: "Name",
                        hintText: "ex. 'John Snow'",
                        prefixIcon: Icon(Icons.account_circle),
                      ),
                      controller: name,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please fill out this form";
                        }
                        if (isSpace(value) != 1) {
                          return "Please fill Name Correctly";
                        }
                      }),
                  TextFormField(
                      decoration: InputDecoration(
                        labelText: "Age",
                        hintText: "Please fill Age Between 10 to 80",
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      controller: age,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please fill Age";
                        } else if (!isAgeTrue(value) ||
                            int.parse(value) <= 10 ||
                            int.parse(value) >= 80) {
                          return "Please fill Age correctly";
                        }
                      }),
                  TextFormField(
                      decoration: InputDecoration(
                        labelText: "Password",
                        hintText: "Password must be longer than 6",
                        prefixIcon: Icon(Icons.lock),
                      ),
                      controller: password,
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value.isEmpty || value.length <= 6) {
                          return "Please fill Password Correctly";
                        }
                      }),
                  RaisedButton(
                      child: Text("REGISTER NEW ACCOUNT"),
                      onPressed: () async {
                        await user.open('user.db');
                        Future<List<User>> allUser = user.getAllUser();
                        User userData = User();
                        userData.userid = userid.text;
                        userData.name = name.text;
                        userData.age = age.text;
                        userData.password = password.text;

                        //function to check if user in
                        Future isNewUserIn(User user) async {
                          var userList = await allUser;
                          for (var i = 0; i < userList.length; i++) {
                            if (user.userid == userList[i].userid) {
                              this.isUserIn = true;
                              break;
                            }
                          }
                        }

                        //call function
                        await isNewUserIn(userData);
                        print(this.isUserIn);

                        //validate form
                        if (_formkey.currentState.validate()) {
                          //if user not exist
                          if (!this.isUserIn) {
                            userid.text = "";
                            name.text = "";
                            age.text = "";
                            password.text = "";
                            repassword.text = "";
                            await user.insertUser(userData);
                            Navigator.of(context).pushReplacementNamed('login');
                            print('insert complete');
                          }
                        }

                        this.isUserIn = false;

                        Future showAllUser() async {
                          var userList = await allUser;
                          for (var i = 0; i < userList.length; i++) {
                            print(userList[i]);
                          }
                        }

                        showAllUser();
                      }),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
