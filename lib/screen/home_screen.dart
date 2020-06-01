import 'package:aula/screen/chat.dart';
import 'package:aula/screen/home_course_list.dart';
import 'package:aula/screen/notif.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

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
      setState(() {});
    });
  }

  void rotate() {
    setState(() {
      rotation = rotation == 0 ? 1 : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width * 0.78;
    return Material(
      color: Colors.blueAccent,
      child: GestureDetector(
        child: Stack(children: [
          Container(
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
              // drawer: Drawer(child: Container()),
              appBar: AppBar(
                backgroundColor: Colors.blueGrey[200],
                leading: IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () {
                      if (acont.status == AnimationStatus.completed) {
                        setState(() {
                          acont.reverse();
                        });
                      } else {
                        setState(() {
                          acont.forward();
                        });
                      }
                    }),
                title: Text('Home'),
                actions: <Widget>[
                  Stack(
                    children: <Widget>[
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) =>
                                        NotificationCentre()));
                          },
                          icon: Icon(Icons.notifications)),
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
                                    builder: (context) => ChatRoom()));
                          },
                          icon: Icon(Icons.chat_bubble)),
                      Positioned(
                          top: 8,
                          right: 8,
                          child: CircleAvatar(
                            radius: 5,
                            backgroundColor: Colors.red,
                          ))
                    ],
                  ),
                ],
              ),

              body: Stack(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                  ),
                  Container(
                    child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 200),
                      reverseDuration: Duration(milliseconds: 200),
                      transitionBuilder: (child, noitamina) {
                        var offsetAnimation = Tween<Offset>(
                                begin: Offset(0.0, 0.1), end: Offset(0.0, 0.0))
                            .animate(noitamina);

                        return SlideTransition(
                          position: offsetAnimation,
                          child:
                              FadeTransition(opacity: noitamina, child: child),
                        );
                      },
                      child: acont.status == AnimationStatus.forward ||
                              acont.status == AnimationStatus.reverse
                          ? Container(
                              color: Colors.transparent,
                              child: Center(
                                child: Text(''),
                              ),
                            )
                          : CourseListHome(),
                    ),
                  ),
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
    var width = MediaQuery.of(context).size.width * 0.78;
    return Container(
      height: double.infinity,
      color: Color.fromRGBO(245, 245, 250, 0.95),
      width: width,
      child: SafeArea(
        child: ListView(
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
              title: Text('Close Sidebar'),
            ),
            ListTile(
              title: Text('Calendar'),
            ),
            ListTile(
              title: Text('Log me out!!'),
            )
          ],
        ),
      ),
    );
  }
}
