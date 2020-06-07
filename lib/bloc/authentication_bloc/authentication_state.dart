import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AuthenticationState extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class AuthUninitialized extends AuthenticationState {
  @override
  String toString() => 'Uninitialized';
}

class Authenticated extends AuthenticationState {
  final String email;
  final String displayName;

  Authenticated(this.displayName, this.email);
  @override
  // TODO: implement props
  List<Object> get props => [displayName, email];

  @override
  String toString() =>
      'Authenticated { displayName: $displayName , email : $email }';
}

class Unauthenticated extends AuthenticationState {
  final bool fromLogOut;
  Unauthenticated(this.fromLogOut);
  @override
  // TODO: implement props
  List<Object> get props => [fromLogOut];

  @override
  String toString() => 'Unauthenticated';
}
