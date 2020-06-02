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
  List menuStatus = [];
  var scrollValue = 0.0, viewControlloffset = 116.0;
  ScrollController scrollController;
  @override
  void initState() {
    scrollController = ScrollController()
      ..addListener(() {
        if (scrollController.offset >= -50 && scrollController.offset <= 180) {
          setState(() {
            scrollValue = scrollController.offset;
          });
        }
        if (scrollController.offset >= 116) {
          // print(viewControlloffset);
          setState(() {
            viewControlloffset = scrollController.offset;
          });
        }
      });

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
            Positioned(top: 12 - (scrollValue * 0.3), child: UserDetailsCard()),
            Positioned.directional(
              textDirection: TextDirection.ltr,
              top: 172,
              child: Container(
                padding: EdgeInsets.zero,
                width: size.width,
                child: Grids(),
              ),
            ),
            Positioned(top: (viewControlloffset), child: ViewControl()),
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
    return Center(
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
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(-3, -3),
                        color: Colors.black12,
                        blurRadius: 4.0),
                    BoxShadow(
                        offset: Offset(3, 3),
                        color: Colors.black12,
                        blurRadius: 4.0),
                  ],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Material(
                    child:
                        IconButton(icon: Icon(Icons.share), onPressed: () {})),
              ),
              //Top Side
              AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  curve: curves,
                  transform: Matrix4.identity()
                    ..translate(openMenu ? 0.0 : -25.0, 0.0, 0.0),
                  margin: EdgeInsets.symmetric(vertical: 6, horizontal: 18),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(-3, -3),
                          color: Colors.black12,
                          blurRadius: 8.0),
                      BoxShadow(
                          offset: Offset(3, 3),
                          color: Colors.black12,
                          blurRadius: 8.0),
                    ],
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
                                // image: DecorationImage(
                                //     image: ),
                                // color: Colors.blue,
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

class ViewControl extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      color: Colors.grey[350],
      width: size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          DropdownButton(items: [
            DropdownMenuItem(child: Text('Filter')),
          ], onChanged: (value) {}),
          DropdownButton(items: [
            DropdownMenuItem(child: Text('Sort')),
          ], onChanged: (value) {}),
        ],
      ),
    );
  }
}
