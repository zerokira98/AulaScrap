import 'package:animations/animations.dart';
// import 'package:aula/bloc/authentication/authentication_bloc.dart';
import 'package:aula/bloc/authentication_bloc/bloc.dart';
import 'package:aula/bloc/cardlist/cardlist_bloc.dart';
import 'package:aula/bloc_delegate.dart';
import 'package:aula/repository/firestore.dart';
import 'package:aula/repository/user_repository.dart';
import 'package:aula/screen/home_screen.dart';
import 'package:aula/screen/signinup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math' as math;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final UserRepository user = UserRepository();
  final FirestoreRepo storage = FirestoreRepo();
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => user),
        RepositoryProvider(create: (context) => storage),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                AuthenticationBloc(userRepository: user)..add(AppStarted()),
          ),
          BlocProvider(
            create: (context) => CardlistBloc()..add(LoadData(5)),
          ),
        ],
        child: MyApp(),
      )));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  AnimationController acont;
  @override
  void initState() {
    acont = AnimationController(vsync: this, duration: Duration(seconds: 2));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        pageTransitionsTheme: PageTransitionsTheme(
          builders: {
            TargetPlatform.android: SharedAxisPageTransitionsBuilder(
                transitionType: SharedAxisTransitionType.horizontal),
            TargetPlatform.iOS: FadeThroughPageTransitionsBuilder(),
          },
        ),
      ),
      home: Scaffold(
        body: PageTransitionSwitcher(
          duration: Duration(milliseconds: 500),
          transitionBuilder: (child, noitamina1, noitamina2) {
            return SharedAxisTransition(
                animation: noitamina1,
                secondaryAnimation: noitamina2,
                transitionType: SharedAxisTransitionType.horizontal,
                child: child);
          },
          child: BlocListener<AuthenticationBloc, AuthenticationState>(
            listener: (context, state) {
              if (state is Authenticated) {
                // Scaffold.of(context).showSnackBar(SnackBar(
                //   content: Text('Hello'),
                // ));
                acont.forward();
                Future.delayed(Duration(seconds: 2), () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomeScreen()));
                });
                // String name = state.displayName;
                // String email = state.email;
                // state
                // context.bloc<AuthenticationBloc>().add(Authenticated(name, email));
              }
            },
            child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (context, state) {
                // if (state is Authenticated) return HomeScreen();
                if (state is Unauthenticated) {
                  return SignInUp(
                    fromlogout: state.fromLogOut,
                  );
                }
                return Splash(acont: acont);
                // Stack(
                //   // crossAxisAlignment: CrossAxisAlignment.center,
                //   // mainAxisAlignment: MainAxisAlignment.center,
                //   children: <Widget>[
                //     Container(
                //         decoration: BoxDecoration(
                //           // color: Colors.blue,
                //           gradient: LinearGradient(
                //               begin: Alignment.topLeft,
                //               end: Alignment.bottomRight,
                //               colors: [
                //                 Colors.blue[600],
                //                 Colors.blue[200],
                //                 Colors.blue[600],
                //               ]),
                //         ),
                //         width: MediaQuery.of(context).size.width,
                //         height: MediaQuery.of(context).size.height),
                //     // Transform.rotate(
                //     //   angle: math.pi / 12,
                //     //   child: Transform.translate(
                //     //     offset: Offset(0.0, -20.0),
                //     //     child: Divider(),
                //     //   ),
                //     // ),
                //     Transform.rotate(
                //         angle: -math.pi * 0.62,
                //         child: Transform.translate(
                //             offset: Offset(-30.0, 0.0),
                //             child: Container(
                //               width: 180,
                //               decoration: BoxDecoration(
                //                   color: Colors.white,
                //                   border:
                //                       Border.all(color: Colors.blue[100])),
                //               // width: 1200,
                //             ))),
                //     Positioned.fill(
                //       child: Column(
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         mainAxisSize: MainAxisSize.max,
                //         children: <Widget>[
                //           Center(
                //             child: Text(
                //               'Aula',
                //               textScaleFactor: 3.2,
                //               style: TextStyle(shadows: [
                //                 Shadow(
                //                     color: Colors.blue[100], blurRadius: 4.0)
                //               ]),
                //               // textAlign: TextAlign.start,
                //             ),
                //           ),
                //           CircularProgressIndicator(),
                //         ],
                //       ),
                //     ),
                //     // Expanded(
                //     //   child: Container(color: Colors.black),
                //     // ),
                //   ],
                // ),
              },
            ),
          ),
        ),
      ),
    );
  }
}

class Splash extends StatefulWidget {
  final AnimationController acont;
  Splash({this.acont});
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  AnimationController acont;
  Animation ani;
  CurvedAnimation curve;
  Tween<double> twe = Tween<double>(
    begin: 0.0,
    end: -80.0,
  );
  @override
  void initState() {
    acont = this.widget.acont;
    curve = CurvedAnimation(parent: acont, curve: Curves.ease);
    ani = twe.animate(curve);
    ani.addListener(() {
      listener();
    });
    super.initState();
  }

  @override
  void dispose() {
    acont.dispose();
    super.dispose();
  }

  void listener() {
    curve.value;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomPaint(
      // clipper: CusClipper(),
      foregroundPainter: CusPaint(ani: ani),
      child: Container(
        child: Center(
          child: InkWell(
            onTap: () async {
              // getData();
              // repo.test();
              // repo.sendMessage('Tes 1 2', 'Candra', 'Afif');
              // print(await repo.getUsernameAvailability('Rizal'));
            },
            child: Card(
              child: Text(
                'Aula',
                textScaleFactor: 3.2,
                style: TextStyle(shadows: [
                  Shadow(color: Colors.blue[100], blurRadius: 4.0)
                ]),
                // textAlign: TextAlign.start,
              ),
            ),
          ),
        ),
      ),
    ));
  }
}

class CusPaint extends CustomPainter {
  CusPaint({this.ani});
  Animation ani;
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.blue;
    var paint2 = Paint();
    paint2.color = Colors.blue;
    // paint2.color = ;

    var path2 = Path();
    path2.moveTo(0, size.height * 0.7 + ani.value);
    path2.relativeLineTo(size.width, -100);
    path2.lineTo(size.width, size.height);
    path2.lineTo(0, size.height);
    path2.close();

    canvas.drawPath(path2, paint);
    canvas.rotate(-math.pi / 1.0);
    canvas.translate(-size.width, -size.height);
    // canvas.transform(mat.storage);
    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
