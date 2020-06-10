import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:aula/repository/user_repository.dart';
import 'package:aula/bloc/authentication_bloc/bloc.dart';
import 'package:aula/screen/login/login.dart';

class LoginForm extends StatefulWidget {
  // final UserRepository _userRepository;
  final PageController _pcontrol;
  LoginForm(
      {Key key,
      // UserRepository userRepository,
      pcontrol})
      :
        // assert(userRepository != null),
        // _userRepository = userRepository,
        _pcontrol = pcontrol,
        super(key: key);

  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginBloc _loginBloc;

  // UserRepository get _userRepository => widget._userRepository;
  PageController get _pcontrol => widget._pcontrol;

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isLoginButtonEnabled(LoginState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
  }

  bool passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    var deviceorient = MediaQuery.of(context).orientation.index;
    var sidemargin = deviceorient == 0 ? 0.40 : 0.6;

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.isFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Login Failure \n ' + state.errorDetails),
                    Icon(Icons.error)
                  ],
                ),
                backgroundColor: Colors.red,
              ),
            );
        }
        if (state.isSubmitting) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Logging In...'),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            );
        }
        if (state.isSuccess) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                backgroundColor: Colors.green,
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Berhasil Login!'),
                  ],
                ),
              ),
            );
          Future.delayed(const Duration(seconds: 3), () {
            BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
          });
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return Container(
            child: Center(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * sidemargin,
                  ),
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(6, 6),
                          color: Colors.black26,
                          blurRadius: 4,
                          spreadRadius: 0,
                        ),
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          bottomLeft: Radius.circular(5))),
                  child: Container(
                    child: Form(
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 18, horizontal: 4),
                              child: Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 24,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            TextFormField(
                                controller: _emailController,
                                // cursorRadius: ,
                                decoration: InputDecoration(
                                  border: UnderlineInputBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(0.0),
                                          topRight: Radius.circular(0.0))),
                                  fillColor: Colors.black12,
                                  // focusColor: Colors.white,
                                  filled: true,
                                  labelStyle: TextStyle(
                                    color: Colors.black,
                                  ),
                                  labelText: 'Email',
                                ),
                                keyboardType: TextInputType.emailAddress,
                                validator: (_) {
                                  return !state.isEmailValid
                                      ? 'Invalid Email'
                                      : null;
                                }),
                            Padding(
                              padding: EdgeInsets.all(8),
                            ),
                            TextFormField(
                                controller: _passwordController,
                                decoration: InputDecoration(
                                  border: UnderlineInputBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(0.0),
                                          topRight: Radius.circular(0.0))),
                                  fillColor: Colors.black12,
                                  // focusColor: Colors.white,
                                  filled: true,
                                  labelStyle: TextStyle(
                                    color: Colors.black,
                                  ),
                                  labelText: 'Password',
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      // Based on passwordVisible state choose the icon
                                      passwordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Theme.of(context).primaryColorDark,
                                    ),
                                    onPressed: () {
                                      // Update the state i.e. toogle the state of passwordVisible variable
                                      setState(() {
                                        passwordVisible = !passwordVisible;
                                      });
                                    },
                                  ),
                                ),
                                keyboardType: TextInputType.text,
                                obscureText: !passwordVisible,
                                autovalidate: false,
                                validator: (_) {
                                  return !state.isPasswordValid
                                      ? 'Invalid Password'
                                      : null;
                                }),
                            Padding(padding: EdgeInsets.all(6)),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: LoginButton(
                                    onPressed: isLoginButtonEnabled(state)
                                        ? _onFormSubmitted
                                        : null,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(4),
                                ),
                                Expanded(
                                  child: RaisedButton(
                                    child: Text('Daftar'),
                                    onPressed: () {
                                      _pcontrol.nextPage(
                                          duration: Duration(milliseconds: 700),
                                          curve: Curves.easeInOut);
                                    },
                                  ),
                                )
                              ],
                            ),
                          ]),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    _loginBloc.add(
      EmailChanged(email: _emailController.text),
    );
  }

  void _onPasswordChanged() {
    _loginBloc.add(
      PasswordChanged(password: _passwordController.text),
    );
  }

  void _onFormSubmitted() {
    // print(_emailController.text);
    _loginBloc.add(
      LoginWithCredentialsPressed(
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
  }
}
