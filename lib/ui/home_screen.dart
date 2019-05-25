import 'package:flutter/material.dart';
import 'package:mobilefinal2/util/state.dart';
import 'package:mobilefinal2/util/user_account.dart';

UserProvider user = UserProvider();

class HomePageScreen extends StatefulWidget {
  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
          children: <Widget>[
            ListTile(
              title: Text('Hello ${CurrentUser.NAME}'),
              subtitle: Text('this is my quote "${CurrentUser.QUOTE}"'),
            ),
            RaisedButton(
              child: Text("PROFILE SETUP"),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/profile');
              },
            ),
            RaisedButton(
              child: Text("MY FRIENDS"),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/friend');
              },
            ),
            RaisedButton(
              child: Text("SIGN OUT"),
              onPressed: () {
                CurrentUser.USERID = null;
                CurrentUser.NAME = null;
                CurrentUser.AGE = null;
                CurrentUser.PASSWORD = null;
                CurrentUser.QUOTE = null;
                Navigator.of(context).pushReplacementNamed('/');
              },
            ),
          ],
      ),
    )
    );
  }

}