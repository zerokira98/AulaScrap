import 'package:animations/animations.dart';
// import 'package:aula/bloc/authentication/authentication_bloc.dart';
import 'package:aula/bloc/authentication_bloc/bloc.dart';
// import 'package:aula/bloc/authentication_bloc/authentication_event.dart';
import 'package:aula/bloc/cardlist/cardlist_bloc.dart';
import 'package:aula/bloc_delegate.dart';
import 'package:aula/repository/user_repository.dart';
import 'package:aula/screen/home_screen.dart';
import 'package:aula/screen/signinup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final UserRepository user = UserRepository();
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(MultiBlocProvider(providers: [
    BlocProvider(
      create: (context) =>
          AuthenticationBloc(userRepository: user)..add(AppStarted()),
    ),
    BlocProvider(
      create: (context) => CardlistBloc()..add(LoadData(5)),
    ),
  ], child: MyApp(userRepository: user)));
}

class MyApp extends StatelessWidget {
  MyApp({this.userRepository});
  final UserRepository userRepository;
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
      home: PageTransitionSwitcher(
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
            if (state is Authenticated) return HomeScreen();
            if (state is Unauthenticated)
              return SignInUp(userRepository: userRepository);
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
