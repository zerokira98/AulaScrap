import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final VoidCallback _onPressed;

  LoginButton({Key key, VoidCallback onPressed})
      : _onPressed = onPressed,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      // color: Colors.green,
      // disabledColor: Colors.redAccent[100],
      // textColor: Colors.white,
      onPressed: _onPressed,
      child: Text('Login'),
    );
  }
}
