part of '../home_course_list.dart';

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
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 24),
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
                          icon: Icon(Icons.visibility_off),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
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
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 24),
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
                                // gradient: RadialGradient(
                                //   colors: [
                                //     Colors.blue[200],
                                //     Colors.blue[700]
                                //   ],
                                // center: Alignment(1.0, 1.0),
                                // radius: 1.8,
                                // ),
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
                                    // shadows: [
                                    //   Shadow(
                                    //     blurRadius: 8,
                                    //   ),
                                    // ],
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
    });
  }
}
