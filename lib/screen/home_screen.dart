import 'dart:ui';

import 'package:aula/bloc/authentication_bloc/bloc.dart';
import 'package:aula/screen/calendar_screen.dart';

import 'package:aula/screen/home_course_list.dart';
import 'package:aula/screen/setting_screen.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  Animation animation;
  AnimationController acont;
  double rotation = 0;

  @override
  void initState() {
    super.initState();
    acont = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    Animation curve = CurvedAnimation(
        parent: acont, curve: Interval(0.2, 0.8, curve: Curves.easeInOut));
    animation = Tween(begin: 0.0, end: 1.0).animate(curve);
    acont.addStatusListener((status) {
      // print(status);
      if (acont.status != AnimationStatus.completed) {
        setState(() {});
      }
    });
  }

  bool visible() {
    bool data = acont.status == AnimationStatus.forward ||
        acont.status == AnimationStatus.reverse;
    // print(acont.status);
    return data;
  }

  void rotate() {
    setState(() {
      rotation = rotation == 0 ? 1 : 0;
    });
  }

  void onTaps() {
    if (acont.status == AnimationStatus.completed) {
      setState(() {
        acont.reverse();
      });
    } else {
      setState(() {
        acont.forward();
      });
    }
  }

  @override
  void dispose() {
    acont.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width * 0.7;
    return Material(
      color: Colors.blueAccent,
      child: Scaffold(
        endDrawer: Drawer(),
        body: Stack(children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                  Colors.black87,
                  Colors.deepPurple,
                  Colors.purple
                ])),
            child: FlareActor(
              'res/cloud.flr',
              fit: BoxFit.cover,
              animation: 'move',
            ),
            width: double.infinity,
            height: double.infinity,
          ),
          AnimatedBuilder(
            animation: animation,
            builder: (context, child) => Transform.translate(
              offset: Offset(width * animation.value, 0),
              child: Transform(
                alignment: Alignment.centerLeft,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(-animation.value * math.pi / 2),
                child: child,
              ),
            ),
            child: Scaffold(
              body: Stack(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                  ),
                  Container(
                    // child: PageTransitionSwitcher(
                    //   reverse: true,
                    //   duration: Duration(milliseconds: 300),
                    //   // reverseDuration: Duration(milliseconds: 200),
                    //   transitionBuilder: (child, noitamina, noitamina2) {
                    //     // return child;

                    //     return SharedAxisTransition(
                    //       transitionType: SharedAxisTransitionType.horizontal,
                    //       animation: noitamina,
                    //       secondaryAnimation: noitamina2,
                    //       child: child,
                    //     );
                    //     // FadeTransition(opacity: noitamina, child: child),
                    //   },
                    child:
                        // acont.status == AnimationStatus.forward ||
                        //         acont.status == AnimationStatus.reverse
                        //     ? Container(
                        //         color: Colors.white,
                        //         child: Center(
                        //           child: Text(''),
                        //         ),
                        //       )
                        // :
                        Visibility(
                            maintainState: true,
                            visible: !visible(),
                            replacement: SizedBox.expand(
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                            child: CourseListHome(callback: onTaps)),
                  ),
                  // ),
                ],
              ),
            ),
          ),
          AnimatedBuilder(
            animation: animation,
            builder: (context, child) => Transform.translate(
              offset: Offset(width * (animation.value - 1), 0),
              child: Transform(
                alignment: Alignment.centerRight,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(math.pi / 2 * (1 - animation.value)),
                child: child,
              ),
            ),
            child: SideBar(animationController: acont),
          )
        ]),
      ),
    );
  }
}

class SideBar extends StatelessWidget {
  final AnimationController animationController;
  SideBar({this.animationController});
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width * 0.7;

    var bloc = BlocProvider.of<AuthenticationBloc>(context);
    return Container(
      height: double.infinity,
      width: width,
      padding: EdgeInsets.only(left: 8),
      color: Color.fromRGBO(245, 245, 250, 0.99),
      child: Center(
        child: Builder(
          builder: (context) => ListView(
            shrinkWrap: true,
            children: <Widget>[
              ListTile(
                onTap: () {
                  // rotate();
                  if (animationController.status == AnimationStatus.completed) {
                    animationController.reverse();
                  } else {
                    animationController.forward();
                  }
                },
                leading: Icon(Icons.close),
                title: Text('Close Sidebar'),
              ),
              ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => CalendarScreen()));
                },
                leading: Icon(Icons.calendar_today),
                title: Text('Calendar'),
              ),
              ListTile(
                onTap: () {
                  Scaffold.of(context).openEndDrawer();
                },
                leading: Icon(Icons.account_circle),
                title: Text('Online Users'),
              ),
              ListTile(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SettingScreen()));
                },
                leading: Icon(Icons.settings),
                title: Text('App Settings'),
              ),
              ListTile(
                onTap: () {
                  bloc.add(LoggedOut());
                },
                leading: Icon(Icons.settings_power),
                title: Text('Log me out!!'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
