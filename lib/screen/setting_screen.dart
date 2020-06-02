import 'package:flutter/material.dart';

class SettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Container(
        child: Center(
          child: Text('Settings Page'),
        ),
      ),
    );
  }
}
