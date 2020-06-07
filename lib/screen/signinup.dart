import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aula/repository/user_repository.dart';
import 'package:aula/screen/login/login.dart';
import 'package:aula/screen/register/register.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInUp extends StatefulWidget {
  final UserRepository _userRepository;
  final bool fromlogout;

  SignInUp({Key key, @required UserRepository userRepository, this.fromlogout})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<SignInUp> {
  PageController _pcontroller;
  double devicewidth;
  double paraleffect = 0;
  String welcomeContent;
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  SharedPreferences pre;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((onValue) {
      bool firstopen;
      firstopen = onValue.getBool('firstopen') ?? true;
      if (firstopen) {
        showDialog(
            context: _scaffoldKey.currentContext,
            builder: (context) => AlertDialog(
                  content: Text(
                      'data pengguna disimpan di firebase bukan milik perpusindo. untuk registrasi silahkan mengisi dengan email&password ngawur.'),
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
    )..addListener(_listener);
    WidgetsBinding.instance
        .addPostFrameCallback((_) => Future.delayed(Duration(seconds: 1), () {
              _scaffoldKey.currentState.showSnackBar(
                SnackBar(
                  duration: Duration(seconds: 3),
                  content: Text(welcomeContent),
                ),
              );
            }));
    Future.delayed(Duration(milliseconds: 2000), () {
      _pcontroller
          .animateToPage(1,
              duration: Duration(milliseconds: 500), curve: Curves.easeInOut)
          .whenComplete(() {
        Future.delayed(Duration(milliseconds: 1000), () {
          _pcontroller.animateToPage(0,
              duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
        });
      });
    });
  }

  void _listener() {
    setState(() {
      paraleffect = _pcontroller.offset / (devicewidth * 2);
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
              create: (context) =>
                  LoginBloc(userRepository: widget._userRepository),
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        alignment: Alignment(0.0 - paraleffect, 0.0),
                        image: AssetImage('res/signscreen/login-default.jpg'),
                        fit: BoxFit.cover)),
                child: LoginForm(
                  userRepository: widget._userRepository,
                  pcontrol: _pcontroller,
                ),
              ),
            ),
            BlocProvider<RegisterBloc>(
              create: (context) =>
                  RegisterBloc(userRepository: widget._userRepository),
              child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage('res/signscreen/regist-default.jpg'),
                    fit: BoxFit.cover,
                    alignment: Alignment(1 - (paraleffect - 0.15), 0),
                  )),
                  child: RegisterForm(pcontrol: _pcontroller)),
            ),
          ],
        ));
  }
}
