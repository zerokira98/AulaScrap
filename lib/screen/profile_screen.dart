import 'dart:io';
// import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavbar(),
      body: Column(children: [
        UserDetailsCard(),
      ]),
    );
  }
}

class BottomNavbar extends StatefulWidget {
  @override
  _BottomNavbarState createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  var index = 0;
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        onTap: (i) {
          setState(() {
            index = i;
          });
        },
        currentIndex: index,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.details), label: ('details')),
          BottomNavigationBarItem(
              icon: Icon(Icons.art_track), label: ('details')),
          BottomNavigationBarItem(
              icon: Icon(Icons.playlist_add_check), label: ('details')),
        ]);
  }
}

class UserDetailsCard extends StatelessWidget {
  @override
  Widget build(context) {
    var width = MediaQuery.of(context).size.width;
    return Hero(
      tag: 'profilecard',
      child: Center(
        child: Container(
          decoration: BoxDecoration(
              color: Colors.purple,
              boxShadow: [
                BoxShadow(
                  spreadRadius: 0.0,
                  blurRadius: 8.0,
                )
              ],
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(48),
                  bottomRight: Radius.circular(48))),
          padding: EdgeInsets.fromLTRB(24.0, 68.0, 24.0, 8.0),
          width: width,
          height: 160,
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ProfilePict(),
              Padding(padding: EdgeInsets.only(left: 16)),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Material(
                    color: Colors.transparent,
                    child: Text(
                      'Nama Lengkap',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: Text(
                      'S1 Ekonomi Bisnis',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                    // color: Colors.purple,
                    ),
              ),
              // Column(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: <Widget>[
              //     Container(
              //       // alignment: Alignment.topCenter,
              //       height: 30,
              //       width: 30,
              //       decoration: BoxDecoration(
              //         shape: BoxShape.circle,
              //         color: Theme.of(context).primaryColor,
              //       ),
              //       // child: IconButton(
              //       //     iconSize: 14,
              //       //     icon: Icon(Icons.arrow_forward),
              //       //     onPressed: () {
              //       //       Navigator.push(
              //       //           context,
              //       //           CupertinoPageRoute(
              //       //               builder: (context) => ProfileScreen()));
              //       //     }),
              //     ),
              //   ],
              // )
            ],
          ),
        ),
      ),
    );
  }
}

class ProfilePict extends StatefulWidget {
  @override
  _ProfilePictState createState() => _ProfilePictState();
}

class _ProfilePictState extends State<ProfilePict> {
  File _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          print('tapped');
          getImage();
        },
        child: CircleAvatar(
          backgroundImage: _image != null ? FileImage(_image) : null,
          // child: _image != null ? Image.file(_image) : Container(),
          radius: 28,
        ),
      ),
    );
  }
}
