import 'package:flutter/material.dart';
// import 'home_course_list.dart';

class CourseScreen extends StatelessWidget {
  CourseScreen(this.i);
  final int i;
  final PageController pgController = PageController();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: BottomNavBar(pc: pgController),
      // appBar: AppBar(
      //   title: Text('Course Details'),
      //   centerTitle: true,
      // ),
      body: Stack(
        children: <Widget>[
          Container(
            width: size.width,
            height: size.height,
          ),
          Positioned(
            // top: 140,
            child: Container(
              height: size.height,
              width: size.width,
              child: PageView(
                controller: pgController,
                children: <Widget>[
                  SingleChildScrollView(
                    padding: EdgeInsets.only(top: 140),
                    child: Column(
                      children: <Widget>[
                        for (var i = 0; i < 3; i++) CardPerMinggu(),
                      ],
                    ),
                  ),
                  Container(),
                ],
              ),
            ),
          ),
          Container(
            child: Hero(
                tag: 'cbanner$i', child: CourseCard(openMenu: true, index: i)),
          ),
        ],
      ),
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
    // CardlistBloc blocs = BlocProvider.of<CardlistBloc>(context);
    // ExpansionTile(title: null)
    return Container(
      height: 140,
      child: Stack(
        children: <Widget>[
          AnimatedContainer(
              duration: Duration(milliseconds: 500),
              curve: curves,
              transform: Matrix4.identity()
                ..translate(openMenu ? 0.0 : -25.0, 0.0, 0.0),
              // margin: EdgeInsets.symmetric(vertical: 6, horizontal: 18),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      offset: Offset(-3, -3),
                      color: Colors.black26,
                      blurRadius: 4.0),
                  BoxShadow(
                      offset: Offset(3, 3),
                      color: Colors.black26,
                      blurRadius: 4.0),
                ],
                // borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Stack(children: [
                      Container(
                        // child: Image.asset(),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('res/coursebg/image' +
                                  (index % 2).toString() +
                                  '.png'),
                              fit: BoxFit.cover),
                          // color: Colors.blue,
                          gradient: RadialGradient(
                            colors: [Colors.blue[200], Colors.blue[700]],
                            center: Alignment(1.0, 1.0),
                            radius: 1.8,
                          ),
                        ),
                      ),
                      Positioned(
                          child: SafeArea(
                        child: Material(
                          color: Colors.transparent,
                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.arrow_back),
                          ),
                        ),
                      ))
                    ]),
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    padding: EdgeInsets.only(top: 4, bottom: 4),
                    decoration: BoxDecoration(color: Colors.white),
                    child: Material(
                      color: Colors.transparent,
                      child: Text(
                        openMenu.toString() + 'title panjang aldfjhdjksdkjds ',
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
}

class CardPerMinggu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return StreamBuilder<Object>(
        stream: null,
        builder: (context, state) {
          return Column(
            children: <Widget>[
              Container(
                  width: size.width,
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[100],
                  ),
                  child: Text(
                    'Minggu ke-xx',
                    textScaleFactor: 1.2,
                  )),
              for (var i = 0; i < 3; i++) ListItems(),
            ],
          );
        });
  }
}

class ListItems extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
        child: Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(8),
              child: Text('[item type]'),
            ),
            Expanded(
              child: Container(
                child: Text('Title'),
              ),
            )
          ],
        ),
        Container(
          padding: EdgeInsets.all(8),
          width: size.width,
          child: Text('Description'),
        ),
      ],
    ));
  }
}

class BottomNavBar extends StatefulWidget {
  BottomNavBar({this.pc});
  final PageController pc;
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.blueGrey[50],
      type: BottomNavigationBarType.shifting,
      currentIndex: index,
      onTap: (i) {
        setState(() {
          index = i;
        });
        this.widget.pc.animateToPage(i,
            duration: Duration(milliseconds: 500), curve: Curves.ease);
      },
      items: [
        BottomNavigationBarItem(
            backgroundColor: Colors.blueGrey[400],
            icon: Icon(Icons.home),
            label: ('Hai')),
        BottomNavigationBarItem(
            backgroundColor: Colors.blueGrey[600],
            icon: Icon(Icons.account_box),
            label: ('Participant')),
      ],
    );
  }
}
