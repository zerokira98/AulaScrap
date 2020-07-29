import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:aula/bloc/authentication_bloc/bloc.dart';
import 'package:aula/repository/user_repository.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository _userRepository;

  AuthenticationBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(AuthUninitialized(displayName: 'init'));

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      await Future.delayed(Duration(seconds: 2));
      yield* _mapAppStartedToState();
    } else if (event is LoggedIn) {
      yield* _mapLoggedInToState();
    } else if (event is LoggedOut) {
      yield* _mapLoggedOutToState(event);
    }
  }

  Stream<AuthenticationState> _mapAppStartedToState() async* {
    // await Future.delayed(
    //   Duration(
    //     seconds: 3,
    //   ),
    // );
    try {
      print('here');
      final isSignedIn = await _userRepository.isSignedIn();

      if (isSignedIn) {
        final email = await _userRepository.getUser();
        final name = await _userRepository.getUserName();
        // yield AuthUninitialized.initialized(name, email);

        yield AuthUninitialized.initialized(
            displayName: name, email: email, success: true);
        // yield Authenticated(name, email);
      } else {
        yield AuthUninitialized.initialized(success: false);
      }
    } catch (_) {
      yield Unauthenticated();
    }
  }

  Stream<AuthenticationState> _mapLoggedInToState() async* {
    yield Authenticated(
        await _userRepository.getUserName(), await _userRepository.getUser());
  }

  Stream<AuthenticationState> _mapLoggedOutToState(
      AuthenticationEvent event) async* {
    bool status = !((event as LoggedOut).initial) ?? true;
    try {
      _userRepository.signOut();
    } catch (e) {
      print(e);
    }
    yield Unauthenticated(fromLogOut: status);
  }
}
