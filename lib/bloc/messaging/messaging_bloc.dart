import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'messaging_event.dart';
part 'messaging_state.dart';

class MessagingBloc extends Bloc<MessagingEvent, MessagingState> {
  bool exist = false;
  @override
  MessagingState get initialState => MessagingInitial();

  @override
  Stream<MessagingState> mapEventToState(
    MessagingEvent event,
  ) async* {
    if (event is Initialize) {
      List<Map> data1 = [
        {
          'idTo': 'email@email.com',
          'isActive': true,
        },
        {
          'idTo': 'rizal@email.com',
          'isActive': false,
        },
      ];
      List data0 = ['Hello mfs'];
      yield Complete(messages: data0, sideChat: data1);
    }
    if (event is ShowMessages) {
      (state as Complete).sideChat.forEach((element) {
        element['isActive'] = false;
        if (element['idTo'] == event.idTo) {
          exist = true;
          element['isActive'] = true;
        }
      });
      if (exist) {
        // yield Complete(messages: ,sideChat: );
      }
    }
  }
}
