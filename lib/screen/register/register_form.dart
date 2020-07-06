import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aula/bloc/authentication_bloc/bloc.dart';
import 'package:aula/screen/register/register.dart';

class RegisterForm extends StatefulWidget {
  final PageController _pcontrol;
  RegisterForm({@required PageController pcontrol}) : this._pcontrol = pcontrol;
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  PageController get _controller => widget._pcontrol;
  RegisterBloc _registerBloc;
  bool passwordVisibled = false;

  bool get isPopulated =>
      _emailController.text.isNotEmpty &&
      _passwordController.text.isNotEmpty &&
      _usernameController.text.isNotEmpty;

  bool isRegisterButtonEnabled(RegisterState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _registerBloc = BlocProvider.of<RegisterBloc>(context);
    _emailController.addListener(_onEmailChanged);
    _usernameController.addListener(_changeUsername);
    _passwordController.addListener(_onPasswordChanged);
  }

  @override
  Widget build(BuildContext context) {
    var deviceorient = MediaQuery.of(context).orientation.index;

    var sidemargin = deviceorient == 0 ? 0.4 : 0.6;

    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        var hai = BlocProvider.of<RegisterBloc>(context);
        print(hai);
        if (state.isSubmitting) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                duration: Duration(seconds: 8),
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Registering...'),
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
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Registration Success, creating profile data...'),
                    Icon(Icons.check),
                  ],
                ),
                backgroundColor: Colors.red,
              ),
            );
        }
        if (state is Success2) {
          Scaffold.of(context).hideCurrentSnackBar();
          BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
        }
        if (state.isFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Registration Failure'),
                    Icon(Icons.error),
                  ],
                ),
                backgroundColor: Colors.red,
              ),
            );
        }
      },
      child: BlocBuilder<RegisterBloc, RegisterState>(
        builder: (context, state) {
          return Container(
            child: Center(
              child: Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width * sidemargin),
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
                        topRight: Radius.circular(5),
                        bottomRight: Radius.circular(5))),
                child: SingleChildScrollView(
                  child: Container(
                    child: Form(
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.fromLTRB(8, 18, 10, 14),
                              child: Text(
                                'Daftar',
                                style: TextStyle(
                                  fontSize: 24,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                            TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Email',
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (_) {
                                return !state.isEmailValid
                                    ? 'Invalid Email'
                                    : null;
                              },
                            ),
                            Padding(
                              padding: EdgeInsets.all(8),
                            ),
                            TextFormField(
                              controller: _passwordController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Password',
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    // Based on passwordVisible state choose the icon
                                    passwordVisibled
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Theme.of(context).primaryColorDark,
                                  ),
                                  onPressed: () {
                                    // Update the state i.e. toogle the state of passwordVisible variable
                                    setState(() {
                                      passwordVisibled = !passwordVisibled;
                                    });
                                  },
                                ),
                              ),
                              keyboardType: TextInputType.text,
                              obscureText: !passwordVisibled,
                              autovalidate: true,
                              validator: (_) {
                                return !state.isPasswordValid
                                    ? 'Invalid Password'
                                    : null;
                              },
                            ),
                            Padding(
                              padding: EdgeInsets.all(8),
                            ),
                            TextFormField(
                              controller: _usernameController,
                              autovalidate: true,
                              validator: (_) {
                                return !state.isUsernameValid
                                    ? 'Username has taken'
                                    : null;
                              },
                              decoration: InputDecoration(
                                  hintText: 'Username', labelText: 'Username'),
                            ),
                            Padding(padding: EdgeInsets.all(12)),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: RegisterButton(
                                    onPressed: isRegisterButtonEnabled(state)
                                        ? _onFormSubmitted
                                        : null,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(4),
                                ),
                                Expanded(
                                  child: RaisedButton(
                                    child: Text('Login'),
                                    onPressed: () {
                                      _controller.previousPage(
                                          duration: Duration(milliseconds: 750),
                                          curve: Curves.ease);
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
    _registerBloc.add(
      EmailChanged(email: _emailController.text),
    );
  }

  void _onPasswordChanged() {
    _registerBloc.add(
      PasswordChanged(password: _passwordController.text),
    );
  }

  void _changeUsername() {
    _registerBloc.add(NameChange(username: _usernameController.text));
  }

  void _onFormSubmitted() {
    _registerBloc.add(
      Submitted(
        email: _emailController.text,
        password: _passwordController.text,
        username: _usernameController.text,
      ),
    );
  }
}
