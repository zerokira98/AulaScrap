import 'package:aula/repository/firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aula/repository/user_repository.dart';
import 'package:aula/screen/login/login.dart';
import 'package:aula/screen/register/register.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInUp extends StatefulWidget {
  final bool fromlogout;

  SignInUp({
    Key key,
    this.fromlogout,
  }) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<SignInUp> {
  FirestoreRepo _firestore;
  UserRepository _userRepository;
  PageController _pcontroller;
  double paraleffect = 0.0;
  double devicewidth;
  String welcomeContent;
  SharedPreferences pre;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    _firestore = RepositoryProvider.of<FirestoreRepo>(context);
    _userRepository = RepositoryProvider.of<UserRepository>(context);
    super.initState();

    SharedPreferences.getInstance().then((onValue) {
      bool firstopen;
      firstopen = onValue.getBool('firstopen') ?? true;
      if (firstopen) {
        showDialog(
            context: _scaffoldKey.currentContext,
            builder: (context) => AlertDialog(
                  content: Text(
                      'data pengguna disimpan di firebase bukan milik []. untuk registrasi silahkan mengisi dengan email&password ngawur.'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Ok, Saya Mengerti'),
                      onPressed: () {
                        onValue.setBool('firstopen', false);
                        Navigator.pop(context);
                      },
                    )
                  ],
                ));
      }
    });

    welcomeContent = widget.fromlogout == true
        ? 'Berhasil logout!'
        : 'Masuk terlebih dahulu';
    _pcontroller = new PageController(
      initialPage: 0,
    );
    WidgetsBinding.instance
        .addPostFrameCallback((_) => Future.delayed(Duration(seconds: 1), () {
              _scaffoldKey.currentState.showSnackBar(
                SnackBar(
                  duration: Duration(seconds: 3),
                  content: Text(welcomeContent),
                ),
              );
              Future.delayed(Duration(seconds: 5), () {
                _scaffoldKey.currentState.hideCurrentSnackBar();
              });
            }));
    Future.delayed(Duration(milliseconds: 2000), () {
      _pcontroller
          .animateToPage(1,
              duration: Duration(milliseconds: 500), curve: Curves.easeInOut)
          .whenComplete(() {
        Future.delayed(Duration(milliseconds: 1200), () {
          _pcontroller.animateToPage(0,
              duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
        });
      });
    });
  }

  @override
  void dispose() {
    _pcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    devicewidth = MediaQuery.of(context).size.width;

    return Scaffold(
        key: _scaffoldKey,
        body: PageView(
          controller: _pcontroller,
          children: <Widget>[
            BlocProvider<LoginBloc>(
              create: (context) => LoginBloc(userRepository: _userRepository),
              child: Stack(
                children: <Widget>[
                  BackGround(
                    pcontrol: _pcontroller,
                    image: 'res/signscreen/login-default.jpg',
                    align: -0.1,
                  ),
                  LoginForm(
                    pcontrol: _pcontroller,
                  ),
                ],
              ),
              // ),
            ),
            BlocProvider<RegisterBloc>(
                create: (context) => RegisterBloc(
                    userRepository: _userRepository, firestore: _firestore),
                child: Stack(
                  children: <Widget>[
                    BackGround(
                      pcontrol: _pcontroller,
                      image: 'res/signscreen/regist-default.jpg',
                      align: 1.0,
                    ),
                    RegisterForm(pcontrol: _pcontroller),
                  ],
                )),
          ],
        ));
  }
}

class BackGround extends StatefulWidget {
  BackGround({this.pcontrol, this.image, this.align});
  final double align;
  final String image;
  final PageController pcontrol;
  @override
  _BackGroundState createState() => _BackGroundState();
}

class _BackGroundState extends State<BackGround> {
  double paraleffect = 0.0;
  double devicewidth;
  @override
  void initState() {
    widget.pcontrol.addListener(_listener);
    super.initState();
  }

  void _listener() {
    if (mounted) {
      setState(() {
        paraleffect = widget.pcontrol.offset / (devicewidth * 1.82);
      });
    }
  }

  // @override
  // void dispose() {

  //   widget.pcontrol.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    devicewidth = MediaQuery.of(context).size.width;
    var deviceheight = MediaQuery.of(context).size.height;
    return Container(
      width: devicewidth,
      height: deviceheight,
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage(widget.image),
        fit: BoxFit.cover,
        alignment: Alignment(widget.align - (paraleffect - 0.15), 0),
      )),
    );
  }
}
