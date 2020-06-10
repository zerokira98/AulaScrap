import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class RegisterEvent extends Equatable {
  // RegisterEvent([List props = const []]) : super(props);
  @override
  List<Object> get props => [];
}

class EmailChanged extends RegisterEvent {
  final String email;

  EmailChanged({@required this.email});

  @override
  List<Object> get props => [email];

  @override
  String toString() => 'EmailChanged { email :$email }';
}

class PasswordChanged extends RegisterEvent {
  final String password;

  PasswordChanged({@required this.password});
  @override
  List<Object> get props => [password];

  @override
  String toString() => 'PasswordChanged { password: $password }';
}

class NameChange extends RegisterEvent {
  final String username;
  NameChange({@required this.username});

  @override
  List<Object> get props => [username];
  @override
  String toString() {
    return 'Changed { username : $username }';
  }
}

class NameSubmit extends RegisterEvent {
  final String username;
  NameSubmit({@required this.username});

  @override
  List<Object> get props => [username];
  @override
  String toString() {
    return 'Submitted { username : $username }';
  }
}

class Submitted extends RegisterEvent {
  final String email;
  final String password;
  final String username;

  Submitted({
    @required this.email,
    @required this.password,
    @required this.username,
  });
  @override
  List<Object> get props => [email, password, username];
  @override
  String toString() {
    return 'Submitted { email: $email, password: $password ,username:$username}';
  }
}
