part of '../home_course_list.dart';

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
      if (off <= 88 && off >= 0.0) {
        setState(() {
          opacity = off != 0.0 ? off / 88 : 0.0;
        });
      } else {
        if (opacity != 1.0) {
          setState(() {
            opacity = 1.0;
          });
        }
      }
      // setState(() {
      //   top = off;
      // });
    });
    super.initState();
  }

  @override
  void dispose() {
    // widget.pc?.dispose();
    super.dispose();
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
