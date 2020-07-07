import 'dart:io';
import 'dart:ui';

import 'package:aula/bloc/messaging/messaging_bloc.dart' as msgbloc;
import 'package:aula/repository/firestore.dart';
import 'package:aula/repository/user_repository.dart';
import 'package:aula/screen/chat.dart';
import 'package:aula/screen/course_screen.dart';
import 'package:aula/screen/notif.dart';
import 'package:aula/screen/profile_screen.dart';
// import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aula/bloc/cardlist/cardlist_bloc.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class CourseListHome extends StatefulWidget {
  final Function callback;
  CourseListHome({this.callback});
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
    // var orient = MediaQuery.of(context).orientation.index;
    var size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
          gradient: RadialGradient(
        colors: [Colors.grey[100], Colors.grey[300]],
        center: Alignment(-1.0, -1.0),
        radius: 1.8,
      )),
      child: Stack(
        // fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          // StackSize(),

          Positioned.directional(
            textDirection: TextDirection.ltr,
            top: 0,
            child: Container(
              padding: EdgeInsets.zero,
              width: size.width,
              height: size.height,
              child: SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                      padding: EdgeInsets.only(top: 228), child: Grids())),
            ),
          ),
          UserDetailsCard(scont: scrollController),
          MenuAppBar(callback: widget.callback, pc: scrollController),
          ViewControl(scont: scrollController),
          // Positioned(top: (viewControlloffset), child: ViewControl()),
        ],
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

class MenuAppBar extends StatefulWidget {
  MenuAppBar({this.callback, this.pc});
  final ScrollController pc;
  final Function callback;

  @override
  _MenuAppBarState createState() => _MenuAppBarState();
}

class _MenuAppBarState extends State<MenuAppBar> {
  final iconColor = Colors.white;
  double top = 0.0, opacity = 0.0;
  @override
  void initState() {
    widget.pc.addListener(() {
      var off = widget.pc.offset;
      if (off <= 88) {
        setState(() {
          opacity = off != 0.0 ? off / 88 : 0.0;
        });
      } else {
        opacity = 1.0;
      }
      // setState(() {
      //   top = off;
      // });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var firestoreRepo = RepositoryProvider.of<FirestoreRepo>(context);
    var userRepo = RepositoryProvider.of<UserRepository>(context);
    return Positioned(
      top: top,
      child: Container(
        padding: EdgeInsets.fromLTRB(24, 24, 14, 8),
        width: size.width,
        color: Colors.purple[600].withOpacity(opacity),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            InkWell(
              onTap: widget.callback,
              child: Container(
                padding: EdgeInsets.all(4),
                child: Icon(Icons.menu, color: iconColor),
              ),
            ),
            Row(children: [
              Stack(
                children: <Widget>[
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => NotificationCentre()));
                      },
                      icon: Icon(
                        Icons.notifications,
                        color: iconColor,
                      )),
                  Positioned(
                      top: 8,
                      right: 8,
                      child: CircleAvatar(
                        radius: 5,
                        backgroundColor: Colors.red,
                      ))
                ],
              ),
              Stack(
                children: <Widget>[
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => BlocProvider(
                                    create: (context) => msgbloc.MessagingBloc(
                                        firestoreRepo, userRepo)
                                      ..add(msgbloc.Initialize()),
                                    child: ChatRoom())));
                      },
                      icon: Icon(
                        Icons.chat_bubble,
                        color: iconColor,
                      )),
                  Positioned(
                      top: 8,
                      right: 8,
                      child: CircleAvatar(
                        radius: 5,
                        backgroundColor: Colors.red,
                      ))
                ],
              ),
            ])
          ],
        ),
      ),
    );
  }
}

class UserDetailsCard extends StatefulWidget {
  UserDetailsCard({this.scont});
  final ScrollController scont;

  @override
  _UserDetailsCardState createState() => _UserDetailsCardState();
}

class _UserDetailsCardState extends State<UserDetailsCard> {
  double pos = 0;
  @override
  void initState() {
    widget.scont.addListener(() {
      listen();
    });
    super.initState();
  }

  void listen() {
    if (mounted && widget.scont.offset < 110) {
      setState(() {
        pos = -widget.scont.offset / 2.5;
      });
    }
  }

  @override
  void dispose() {
    widget.scont.dispose();
    super.dispose();
  }

  @override
  Widget build(context) {
    var width = MediaQuery.of(context).size.width;
    return Positioned(
      top: pos,
      child: Hero(
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
                    FutureBuilder(
                        future:
                            context.repository<UserRepository>().getUserName(),
                        builder: (context, snapshot) {
                          return Material(
                            color: Colors.transparent,
                            child: Text(
                              snapshot.data ?? '',
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        }),
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
                      child: Material(
                        color: Colors.transparent,
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
    // print(dir);
    return _image = File(dir);
  }

  Future getImage() async {
    // var str = await Permission.mediaLibrary.request();
    var pickedFile = await picker.getImage(source: ImageSource.gallery);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (pickedFile == null) return;
    //get sys dir
    var listAppDocDir =
        await getExternalStorageDirectories(type: StorageDirectory.pictures);
    Directory appDocDir = listAppDocDir[0];

    // Directory appDir = Directory('/storage/emulated/0/Downloads/');

    String appDocPath = appDocDir.path;
    // '/storage/emulated/0/Pictures';
    // print(Permission.values);
    // print(appDir.existsSync());

// copy the file to a new path
    var extensi = (extension(pickedFile.path));
    try {
      var tgl = DateTime.now();
      String fileLama = prefs.getString('profile_picture');
      print('$fileLama');
      if (fileLama != null) {
        if (await File(fileLama).exists()) {
          await File(fileLama).delete();
        }
        prefs.remove('profile_picture');
      }
      String namaFile = tgl.minute.toString() + tgl.second.toString();
      String newDir = '$appDocPath/$namaFile' 'pp$extensi';
      File newImage = await File(pickedFile.path).copy(newDir);
      //set shpref
      prefs.setString('profile_picture', newImage.path);
      print(newImage.path);
      setState(() {
        _image = File(newImage.path);
      });
    } catch (e) {
      print(e);
    }
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
        child: FutureBuilder(
            // stream: null,
            future: setup(),
            builder: (context, snapshot) {
              return CircleAvatar(
                backgroundImage: _image != null ? FileImage(_image) : null,
                radius: 28,
              );
            }),
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
                .map((i, e) {
                  if (state.currentFilter == 5) {
                    if (state.data[i]['hidden']) {
                      // return MapEntry(i, Container());
                    } else {
                      return MapEntry(i, Container());
                    }
                  } else if (state.data[i]['hidden']) {
                    return MapEntry(i, Container());
                  }

                  return MapEntry(
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
                            openMenu: state.data[i]['close'],
                          ),
                        )),
                  );
                })
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
    return AnimatedOpacity(
      opacity: 1.0,
      curve: Curves.ease,
      duration: Duration(seconds: 1),
      child:
          BlocBuilder<CardlistBloc, CardlistState>(builder: (context, state) {
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
                          color: Colors.black12,
                          blurRadius: 2.0,
                          spreadRadius: 2.0),
                    ],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Material(
                        color: Colors.transparent,
                        child: IconButton(
                            icon: Icon(Icons.visibility_off),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  child: AlertDialog(
                                    content: Text(
                                        'Are you sure to hide/unhide this course?'),
                                    actions: <Widget>[
                                      MaterialButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Cancel'),
                                      ),
                                      MaterialButton(
                                        onPressed: () {
                                          context
                                              .bloc<CardlistBloc>()
                                              .add(HideCard(index));
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Ok'),
                                      ),
                                    ],
                                  ));
                            }),
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
                                    colors: [
                                      Colors.blue[200],
                                      Colors.blue[700]
                                    ],
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
        return CircularProgressIndicator();
      }),
    );
  }
}

class ViewControl extends StatefulWidget {
  ViewControl({this.scont});
  final ScrollController scont;
  @override
  _ViewControlState createState() => _ViewControlState();
}

class _ViewControlState extends State<ViewControl> {
  var viewControlloffset = 172.0;
  int filterVal = 0;
  int sortByVal = 0;
  var style = TextStyle(fontSize: 12.0);
  @override
  void initState() {
    this.widget.scont.addListener(() {
      listen();
    });
    super.initState();
  }

  void listen() {
    if (this.widget.scont.offset <= 100) {
      setState(() {
        viewControlloffset = 172 - this.widget.scont.offset;
      });
    }
    // else if (viewControlloffset >= 64.0) {
    //   setState(() {
    //     viewControlloffset = 64.0;
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Positioned(
      top: viewControlloffset,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                offset: Offset(0, 4), blurRadius: 4.0, color: Colors.grey),
          ],
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
                          child: Text(
                            'All(Except Hidden)',
                            style: style,
                          ),
                          value: 0),
                      DropdownMenuItem(
                          child: Text(
                            'In progress',
                            style: style,
                          ),
                          value: 1),
                      DropdownMenuItem(
                          child: Text(
                            'Future',
                            style: style,
                          ),
                          value: 2),
                      DropdownMenuItem(
                          child: Text(
                            'Past',
                            style: style,
                          ),
                          value: 3),
                      DropdownMenuItem(
                          child: Text(
                            'Starred',
                            style: style,
                          ),
                          value: 4),
                      DropdownMenuItem(
                          child: Text(
                            'Hidden',
                            style: style,
                          ),
                          value: 5),
                    ],
                    onChanged: (value) {
                      setState(() {
                        context.bloc<CardlistBloc>().add(ChangeFilter(value));
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
                      DropdownMenuItem(
                          child: Text(
                            'Course Name',
                            style: style,
                          ),
                          value: 0),
                      DropdownMenuItem(
                          child: Text(
                            'Last Accessed',
                            style: style,
                          ),
                          value: 1),
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
