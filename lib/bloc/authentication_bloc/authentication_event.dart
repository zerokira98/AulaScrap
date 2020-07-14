import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AuthenticationEvent extends Equatable {
  // AuthenticationEvent([List props = const []]) ;
  @override
  List<Object> get props => [];
}

class AppStarted extends AuthenticationEvent {
  @override
  String toString() => 'AppStarted';
}

class LoggedIn extends AuthenticationEvent {
  @override
  String toString() => 'LoggedIn';
}

class LoggedOut extends AuthenticationEvent {
  LoggedOut({this.initial});
  final bool initial;
  @override
  // TODO: implement props
  List<Object> get props => [initial];
  @override
  String toString() => 'LoggedOut';
}
