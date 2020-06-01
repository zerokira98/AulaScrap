import 'dart:async';

import 'package:aula/repository/authentication.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthRepository repo;
  AuthenticationBloc({AuthRepository repository}) {
    repo = repository;
  }
  @override
  AuthenticationState get initialState => AuthenticationInitial();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}