import 'dart:async';
import 'package:aula/repository/firestore.dart';
import 'package:bloc/bloc.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:aula/repository/user_repository.dart';
import 'package:aula/screen/register/register.dart';
import 'package:aula/etc/validators.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final UserRepository _userRepository;
  final FirestoreRepo _firestore;

  RegisterBloc(
      {@required UserRepository userRepository,
      @required FirestoreRepo firestore})
      : assert(userRepository != null),
        assert(firestore != null),
        _firestore = firestore,
        _userRepository = userRepository;

  @override
  RegisterState get initialState => RegisterState.empty();

  @override
  Stream<Transition<RegisterEvent, RegisterState>> transformEvents(
    Stream<RegisterEvent> events,
    TransitionFunction<RegisterEvent, RegisterState> transitionFn,
  ) {
    // final observableStream = events as Observable<RegisterEvent>;
    final nonDebounceStream = events.where((event) {
      return (event is! EmailChanged && event is! PasswordChanged);
    });
    final debounceStream = events.where((event) {
      return (event is EmailChanged || event is PasswordChanged);
    }).debounceTime(Duration(milliseconds: 300));
    return super.transformEvents(
        nonDebounceStream.mergeWith([debounceStream]), transitionFn);
  }

  @override
  Stream<RegisterState> mapEventToState(
    RegisterEvent event,
  ) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is PasswordChanged) {
      yield* _mapPasswordChangedToState(event.password);
    } else if (event is Submitted) {
      yield* _mapFormSubmittedToState(
          event.email, event.password, event.username);
    } else if (event is NameChange) {
      yield* _mapUsernameChangedToState(event.username);
    } else if (event is NameSubmit) {
      yield* _mapUsernameSubmit(event.username);
    }
  }

  Stream<RegisterState> _mapUsernameSubmit(String username) async* {
    try {
      await _userRepository.setUser(username);
      var email = await _userRepository.getUser();
      var data = {
        'name': '$username',
        'email': '$email',
      };
      await _firestore.setUser(data);
      yield RegisterState.success2();
    } catch (e) {
      print(e);
    }
  }

  Stream<RegisterState> _mapEmailChangedToState(String email) async* {
    yield state.update(
      isEmailValid: Validators.isValidEmail(email),
    );
  }

  Stream<RegisterState> _mapPasswordChangedToState(String password) async* {
    yield state.update(
      isPasswordValid: Validators.isValidPassword(password),
    );
  }

  Stream<RegisterState> _mapUsernameChangedToState(String username) async* {
    yield state.update(
      isUsernameValid: await _firestore.getUsernameAvailability(username),
    );
  }

  Stream<RegisterState> _mapFormSubmittedToState(
    String email,
    String password,
    String username,
  ) async* {
    yield RegisterState.loading();
    try {
      await _userRepository.signUp(
        email: email,
        password: password,
      );
      yield RegisterState.success();
      await _userRepository.setUser(username);
      var email1 = await _userRepository.getUser();
      var data = {
        'name': '$username',
        'email': '$email1',
      };
      await _firestore.setUser(data);
      yield RegisterState.success2();
    } catch (e) {
      print(e);
      yield RegisterState.failure();
    }
  }
}
