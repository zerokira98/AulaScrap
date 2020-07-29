import 'dart:io';
import 'dart:ui';

import 'package:aula/bloc/messaging/messaging_bloc.dart' as msgbloc;
import 'package:aula/repository/firestore.dart';
import 'package:aula/repository/user_repository.dart';
import 'package:aula/screen/chat/chat.dart';
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

part 'component/view_control.dart';
part 'component/course_card.dart';
part 'component/appbar_menu.dart';
part 'component/user_card.dart';

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
    scrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // var orient = MediaQuery.of(context).orientation.index;
    var size = MediaQuery.of(context).size;
    return Container(
      // decoration: BoxDecoration(
      //     gradient: RadialGradient(
      //   colors: [Colors.grey[100], Colors.grey[300]],
      //   center: Alignment(-1.0, -1.0),
      //   radius: 1.8,
      // )),
      child: Stack(
        // fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          // StackSize(),
          ///List of course card
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
