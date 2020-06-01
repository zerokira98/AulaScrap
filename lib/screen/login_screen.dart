import 'package:flutter/material.dart';
import 'package:aula/screen/home_screen.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Login Screen'),
              RaisedButton(
                  child: Text('Login'),
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                  })
            ],
          ),
        ),
      ),
    );
  }
}
