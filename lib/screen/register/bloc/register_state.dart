import 'package:meta/meta.dart';

@immutable
class RegisterState {
  final bool isEmailValid;
  final bool isPasswordValid;
  final bool isUsernameValid;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isSuccess2;
  final bool isFailure;

  bool get isFormValid => isEmailValid && isPasswordValid;

  RegisterState({
    @required this.isEmailValid,
    @required this.isPasswordValid,
    @required this.isUsernameValid,
    @required this.isSubmitting,
    @required this.isSuccess,
    @required this.isSuccess2,
    @required this.isFailure,
  });

  factory RegisterState.empty() {
    return RegisterState(
      isEmailValid: true,
      isPasswordValid: true,
      isUsernameValid: true,
      isSubmitting: false,
      isSuccess: false,
      isSuccess2: false,
      isFailure: false,
    );
  }

  factory RegisterState.loading() {
    return RegisterState(
      isEmailValid: true,
      isPasswordValid: true,
      isUsernameValid: true,
      isSubmitting: true,
      isSuccess: false,
      isSuccess2: false,
      isFailure: false,
    );
  }

  factory RegisterState.failure() {
    return RegisterState(
      isEmailValid: true,
      isPasswordValid: true,
      isUsernameValid: true,
      isSubmitting: false,
      isSuccess: false,
      isSuccess2: false,
      isFailure: true,
    );
  }

  factory RegisterState.success() {
    return RegisterState(
      isEmailValid: true,
      isPasswordValid: true,
      isUsernameValid: true,
      isSubmitting: false,
      isSuccess: true,
      isSuccess2: false,
      isFailure: false,
    );
  }

  RegisterState update({
    bool isEmailValid,
    bool isPasswordValid,
    bool isUsernameValid,
  }) {
    return copyWith(
      isEmailValid: isEmailValid,
      isPasswordValid: isPasswordValid,
      isUsernameValid: isUsernameValid,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  RegisterState copyWith({
    bool isEmailValid,
    bool isPasswordValid,
    bool isUsernameValid,
    bool isSubmitEnabled,
    bool isSubmitting,
    bool isSuccess,
    bool isSuccess2,
    bool isFailure,
  }) {
    return RegisterState(
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      isUsernameValid: isUsernameValid ?? this.isUsernameValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isSuccess2: isSuccess2 ?? this.isSuccess2,
      isFailure: isFailure ?? this.isFailure,
    );
  }

  @override
  String toString() {
    return '''RegisterState {
      isEmailValid: $isEmailValid,
      isPasswordValid: $isPasswordValid,      
      isUsernameValid: $isUsernameValid,      
      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      isFailure: $isFailure,
    }''';
  }
}

class Success2 extends RegisterState {
  Success2();

  final bool isEmailValid = true;
  final bool isPasswordValid = true;
  final bool isUsernameValid = true;
  final bool isSubmitting = false;
  final bool isSuccess = false;
  final bool isSuccess2 = true;
  final bool isFailure = false;
}
