import 'package:animations/animations.dart';
// import 'package:aula/bloc/authentication/authentication_bloc.dart';
import 'package:aula/bloc/authentication_bloc/bloc.dart';
import 'package:aula/bloc/cardlist/cardlist_bloc.dart';
import 'package:aula/bloc_delegate.dart';
import 'package:aula/repository/firestore.dart';
import 'package:aula/repository/user_repository.dart';
import 'package:aula/screen/home/home_screen.dart';
import 'package:aula/screen/signinup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math' as math;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final UserRepository user = UserRepository();
  final FirestoreRepo storage = FirestoreRepo();
  Bloc.observer = SimpleBlocDelegate();
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
            create: (context) => CardlistBloc()..add(LoadData(8)),
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
    acont = AnimationController(vsync: this, duration: Duration(seconds: 1));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // fontFamily: 'genuine',
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
        body: BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            if (state is AuthUninitialized) {
              if (state.success) {
                // Scaffold.of(context).showSnackBar(SnackBar(
                //   content: Text('Hello'),
                // ));
                acont.forward();
                Future.delayed(Duration(seconds: 2), () {
                  context.bloc<AuthenticationBloc>().add(LoggedIn());
                  // Navigator.pushReplacement(context,
                  //     MaterialPageRoute(builder: (context) => HomeScreen()));
                });
              }
              if (!state.success) {
                acont.forward();
                Future.delayed(Duration(seconds: 2), () {
                  context
                      .bloc<AuthenticationBloc>()
                      .add(LoggedOut(initial: true));
                });
              }
              // String name = state.displayName;
              // String email = state.email;
              // state
              // context.bloc<AuthenticationBloc>().add(Authenticated(name, email));
            }
            // if ((state as Unauthenticated).fromLogOut) {
            //   Future.delayed(Duration(seconds: 2), () {
            //     Navigator.pushReplacement(
            //         context,
            //         MaterialPageRoute(
            //             builder: (context) => SignInUp(
            //                   fromlogout:
            //                       (state as Unauthenticated).fromLogOut,
            //                 )));
            //   });
            // }
          },
          child: PageTransitionSwitcher(
            duration: Duration(milliseconds: 500),
            transitionBuilder: (child, noitamina1, noitamina2) {
              return SharedAxisTransition(
                  animation: noitamina1,
                  secondaryAnimation: noitamina2,
                  transitionType: SharedAxisTransitionType.horizontal,
                  child: child);
            },
            child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (context, state) {
                var size = MediaQuery.of(context).size;
                if (state is Authenticated) return HomeScreen();
                if (state is Unauthenticated) {
                  return SignInUpHome(
                    fromLogout: state.fromLogOut,
                  );
                }
                if (state is AuthUninitialized) {
                  return Splash(acont: acont, height: size.height);
                }
                return CircularProgressIndicator();
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
  final double height;
  Splash({this.acont, this.height});
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  AnimationController acont;
  Animation ani;
  CurvedAnimation curve;
  Tween<double> twe;
  @override
  void initState() {
    var height = this.widget.height;
    acont = this.widget.acont;
    twe = Tween<double>(
      begin: 0.0,
      end: (height * -0.15) - 5,
    );
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
    print(ani.value);
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
            child: Text(
              'Aula',
              textScaleFactor: 3.3,
              style: TextStyle(
                  shadows: [Shadow(color: Colors.blue[100], blurRadius: 15.0)]),
              // textAlign: TextAlign.start,
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
    path2.relativeLineTo(size.width, -60);
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
