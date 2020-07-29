import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AuthenticationState extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthUninitialized extends AuthenticationState {
  final bool success;
  final String email;
  final String displayName;
  AuthUninitialized({this.displayName, this.email, this.success});
  factory AuthUninitialized.initialized(
      {String displayName, String email, bool success}) {
    return AuthUninitialized(
        displayName: displayName, email: email, success: success);
  }
  @override
  List<Object> get props => [email, displayName, success];
  @override
  String toString() => 'AuthUninitialized';
}

// class AuthInitialized extends AuthUninitialized {
//   final String email;
//   final String displayName;
//   AuthInitialized(this.displayName, this.email);
//   @override
//   String toString() => 'Initialized';
// }

class Authenticated extends AuthenticationState {
  final String email;
  final String displayName;

  Authenticated(this.displayName, this.email);
  @override
  List<Object> get props => [displayName, email];

  @override
  String toString() =>
      'Authenticated { displayName: $displayName , email : $email }';
}

class Unauthenticated extends AuthenticationState {
  final bool fromLogOut;
  Unauthenticated({bool fromLogOut}) : this.fromLogOut = fromLogOut ?? false;
  @override
  List<Object> get props => [fromLogOut];

  @override
  String toString() => 'Unauthenticated';
}
