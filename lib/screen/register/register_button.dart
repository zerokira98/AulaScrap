import 'package:flutter/material.dart';

class RegisterButton extends StatelessWidget {
  final VoidCallback _onPressed;

  RegisterButton({Key key, VoidCallback onPressed})
      : _onPressed = onPressed,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: Colors.blue,
      disabledColor: Colors.blueGrey,
      textColor: Colors.white,
      onPressed: _onPressed,
      child: Text('Register'),
    );
  }
}
