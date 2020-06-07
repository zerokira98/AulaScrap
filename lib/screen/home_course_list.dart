import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:aula/screen/course_screen.dart';
import 'package:aula/screen/profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aula/bloc/cardlist/cardlist_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class CourseListHome extends StatefulWidget {
  @override
  _CourseListHomeState createState() => _CourseListHomeState();
}

class _CourseListHomeState extends State<CourseListHome> {
  final course = [
    {
      'name': 'english abcd class i',
      'id': 2192,
      'bg-img': 'default.jpg',
    },
  ];
  // List menuStatus = [];
  ScrollController scrollController;
  @override
  void initState() {
    scrollController = ScrollController();

    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var orient = MediaQuery.of(context).orientation.index;
    var size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
          gradient: RadialGradient(
        colors: [Colors.grey[100], Colors.grey[300]],
        center: Alignment(-1.0, -1.0),
        radius: 1.8,
      )),
      child: SingleChildScrollView(
        controller: scrollController,
        physics: BouncingScrollPhysics(),
        child: Stack(
          alignment: Alignment.center,
          children: [
            StackSize(),
            Positioned(top: 12, child: UserDetailsCard()),
            Positioned.directional(
              textDirection: TextDirection.ltr,
              top: 178,
              child: Container(
                padding: EdgeInsets.zero,
                width: size.width,
                child: Grids(),
              ),
            ),
            ViewControl(scont: scrollController),
            // Positioned(top: (viewControlloffset), child: ViewControl()),
          ],
        ),
      ),
    );
  }
}

class StackSize extends StatelessWidget {
  @override
  Widget build(context) {
    var size = MediaQuery.of(context).size;
    return BlocBuilder<CardlistBloc, CardlistState>(
      builder: (context, state) {
        if (state is Loaded) {
          double heights = state.cardSize * (state.data.length + 2);
          return Container(
            width: size.width,
            height: size.height > heights ? size.height - 80 : heights,
          );
        } else {
          return Container();
        }
      },
    );
  }
}

class UserDetailsCard extends StatelessWidget {
  @override
  Widget build(context) {
    var width = MediaQuery.of(context).size.width * 0.96;
    return Hero(
      tag: 'profilecard',
      child: Center(
        child: Card(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            width: width,
            height: 90,
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ProfilePict(),
                Padding(padding: EdgeInsets.only(left: 10)),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text('Nama Lengkap'),
                    Text('S1 Ekonomi Bisnis'),
                  ],
                ),
                Expanded(
                  child: Container(
                      // color: Colors.purple,
                      ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      // alignment: Alignment.topCenter,
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).primaryColor,
                      ),
                      child: IconButton(
                          iconSize: 14,
                          icon: Icon(Icons.arrow_forward),
                          onPressed: () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => ProfileScreen()));
                          }),
                    ),
                  ],
                )
              ],
            ),
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

  @override
  void initState() {
    super.initState();
  }

  Future setup() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var dir = prefs.getString('profile_picture');
    return _image = File(dir);
  }

  Future getImage() async {
    var pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile == null) return;
    //get sys dir
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;

// copy the file to a new path
    var extensi = (extension(pickedFile.path));
    final File newImage =
        await File(pickedFile.path).copy('$appDocPath/pp$extensi');

    //set shpref
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('profile_picture', newImage.path);

    setState(() {
      _image = File(newImage.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print('tapped');
        getImage();
      },
      child: FutureBuilder(
          // stream: null,
          future: setup(),
          builder: (context, snapshot) {
            return CircleAvatar(
              backgroundImage: _image != null ? FileImage(_image) : null,
              radius: 28,
            );
          }),
    );
  }
}

class Grids extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //ignore: close_sinks
    final CardlistBloc _cardbloc = BlocProvider.of<CardlistBloc>(context);
    return BlocBuilder<CardlistBloc, CardlistState>(
      // bloc: _cardbloc,
      builder: (context, state) {
        if (state is CardlistInitial) {
          return CircularProgressIndicator();
        }
        if (state is Loading) {
          return CircularProgressIndicator();
        }
        if (state is Loaded) {
          return Column(
            children: state.data
                .asMap()
                .map((i, e) => MapEntry(
                      i,
                      GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(CupertinoPageRoute(
                                builder: (context) => CourseScreen(i)));
                          },
                          onLongPress: () {
                            HapticFeedback.vibrate();
                            SystemSound.play(SystemSoundType.click);
                          },
                          onLongPressUp: () {
                            _cardbloc.add(OpenCard(i));
                          },
                          child: Hero(
                            tag: 'cbanner$i',
                            child: CourseCard(
                              index: i,
                              openMenu: state.data[i],
                            ),
                          )),
                    ))
                .values
                .toList(),
          );
        }
        return Container();
      },
    );
  }
}

class CourseCard extends StatelessWidget {
  final int index;

  CourseCard({
    @required this.openMenu,
    this.index,
  });
  // var xmenu = 0.0, xcard = 0.0;
  final bool openMenu;
  final Curve curves = Curves.ease;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CardlistBloc, CardlistState>(builder: (context, state) {
      if (state is Loaded) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: state.cardSize,
          child: Stack(
            children: <Widget>[
              //Menu at Background
              AnimatedContainer(
                duration: Duration(milliseconds: 500),
                curve: curves,
                alignment: Alignment(1, 0),
                transform: Matrix4.identity()
                  ..translate(openMenu ? 0.0 : 10.0, 0.0, 0.0)
                  ..rotateZ(-1 * (openMenu ? 0.0 : 10.0) / 600),
                margin: EdgeInsets.symmetric(vertical: 6, horizontal: 18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  // boxShadow: [
                  //   BoxShadow(
                  //       color: Colors.black12,
                  //       blurRadius: 2.0,
                  //       spreadRadius: 2.0),
                  // ],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Material(
                      color: Colors.transparent,
                      child: IconButton(
                          icon: Icon(Icons.visibility_off), onPressed: () {}),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: IconButton(
                          icon: Icon(Icons.star_border), onPressed: () {}),
                    ),
                  ],
                ),
              ),
              //Top Side
              AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  curve: curves,
                  transform: Matrix4.identity()
                    ..translate(openMenu ? 0.0 : -25.0, 0.0, 0.0),
                  margin: EdgeInsets.symmetric(vertical: 6, horizontal: 18),
                  decoration: BoxDecoration(
                    // boxShadow: [
                    //   BoxShadow(
                    //       offset: Offset(-3, -3),
                    //       color: Colors.black12,
                    //       blurRadius: 8.0),
                    //   BoxShadow(
                    //       offset: Offset(3, 3),
                    //       color: Colors.black12,
                    //       blurRadius: 8.0),
                    // ],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Stack(children: [
                          Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('res/coursebg/image' +
                                        (index % 2).toString() +
                                        '.png'),
                                    fit: BoxFit.cover),
                                gradient: RadialGradient(
                                  colors: [Colors.blue[200], Colors.blue[700]],
                                  center: Alignment(1.0, 1.0),
                                  radius: 1.8,
                                ),
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(16))),
                          ),
                          Positioned(
                            // top: 0,
                            right: 0,
                            child: Material(
                              color: Colors.transparent,
                              child: IconButton(
                                onPressed: () {
                                  context
                                      .bloc<CardlistBloc>()
                                      .add(OpenCard(index));
                                },
                                icon: Icon(
                                  Icons.more_vert,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                              left: 8,
                              bottom: 8,
                              child: Material(
                                color: Colors.transparent,
                                child: Text(
                                  'Fisika (S1)',
                                  style: TextStyle(
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                                ),
                              ))
                        ]),
                      ),
                      //--------------------------------
                      //Bottom Title ------//
                      Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        padding:
                            EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(16)),
                            color: Colors.white),
                        child: Material(
                          color: Colors.transparent,
                          child: Text(
                            '2019Genap - SII213 - Inovasi Sistem Informasi dan Teknologi - S1 - SISTEM INFORMASI - 2017 - kelas I ',
                            maxLines: 2,
                            textScaleFactor: 1.1,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        );
      }
    });
  }
}

class ViewControl extends StatefulWidget {
  ViewControl({this.scont});
  final ScrollController scont;
  @override
  _ViewControlState createState() => _ViewControlState();
}

class _ViewControlState extends State<ViewControl> {
  var viewControlloffset = 116.0;
  int filterVal = 0;
  int sortByVal = 0;
  @override
  void initState() {
    this.widget.scont.addListener(() {
      if (this.widget.scont.offset >= 116) {
        setState(() {
          viewControlloffset = this.widget.scont.offset;
        });
      } else if (viewControlloffset != 115.0) {
        setState(() {
          viewControlloffset = 115.0;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Positioned(
      top: viewControlloffset,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(offset: Offset(0, 1), blurRadius: 2.0)],
          color: Colors.white,
        ),
        width: size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(Icons.filter_list),
                DropdownButton(
                    value: filterVal,
                    items: [
                      DropdownMenuItem(
                          child: Text('All(Except Hidden)'), value: 0),
                      DropdownMenuItem(child: Text('In progress'), value: 1),
                      DropdownMenuItem(child: Text('Future'), value: 2),
                      DropdownMenuItem(child: Text('Past'), value: 3),
                      DropdownMenuItem(child: Text('Starred'), value: 4),
                      DropdownMenuItem(child: Text('Hidden'), value: 5),
                    ],
                    onChanged: (value) {
                      setState(() {
                        filterVal = value;
                      });
                    }),
              ],
            ),
            Row(
              children: <Widget>[
                Icon(Icons.sort),
                DropdownButton(
                    value: sortByVal,
                    items: [
                      DropdownMenuItem(child: Text('Course Name'), value: 0),
                      DropdownMenuItem(child: Text('Last Accessed'), value: 1),
                    ],
                    onChanged: (value) {
                      setState(() {
                        sortByVal = value;
                      });
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
