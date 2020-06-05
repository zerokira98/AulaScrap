import 'package:animations/animations.dart';
import 'package:aula/bloc/authentication/authentication_bloc.dart';
import 'package:aula/bloc/cardlist/cardlist_bloc.dart';
import 'package:aula/bloc_delegate.dart';
import 'package:aula/repository/authentication.dart';
import 'package:aula/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final AuthRepository user = AuthRepository();
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(MultiBlocProvider(providers: [
    BlocProvider(
      create: (context) =>
          AuthenticationBloc(repository: user)..add(AppStarted()),
    ),
    BlocProvider(
      create: (context) => CardlistBloc()..add(LoadData(5)),
    ),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
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
      home: LoginScreen(),
    );
  }
}
