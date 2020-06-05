import 'dart:io';
// import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavbar(),
      body: SafeArea(
        child: Column(children: [
          Hero(
            tag: 'profilecard',
            child: UserDetailsCard(),
          ),
        ]),
      ),
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
              icon: Icon(Icons.details), title: Text('details')),
          BottomNavigationBarItem(
              icon: Icon(Icons.art_track), title: Text('details')),
          BottomNavigationBarItem(
              icon: Icon(Icons.playlist_add_check), title: Text('details')),
        ]);
  }
}

class UserDetailsCard extends StatelessWidget {
  @override
  Widget build(context) {
    var width = MediaQuery.of(context).size.width * 0.96;
    return Center(
      child: Card(
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 20),
          width: width,
          height: 110,
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              // Padding(padding: EdgeInsets.only(left: 10)),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    ProfilePict(),
                    Text('Nama Lengkap'),
                    Text('S1 Ekonomi Bisnis'),
                  ],
                ),
              ),
              // Expanded(
              //   child: Container(
              //       // color: Colors.purple,
              //       ),
              // ),
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
              //       child: IconButton(
              //           iconSize: 14,
              //           icon: Icon(Icons.arrow_forward),
              //           onPressed: () {
              //             Navigator.push(
              //                 context,
              //                 CupertinoPageRoute(
              //                     builder: (context) => ProfileScreen()));
              //           }),
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
    return InkWell(
      onTap: () {
        print('tapped');
        getImage();
      },
      child: CircleAvatar(
        backgroundImage: _image != null ? FileImage(_image) : null,
        // child: _image != null ? Image.file(_image) : Container(),
        radius: 28,
      ),
    );
  }
}
