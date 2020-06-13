import 'dart:async';

import 'package:aula/repository/firestore.dart';
import 'package:aula/repository/user_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'messaging_event.dart';
part 'messaging_state.dart';

class MessagingBloc extends Bloc<MessagingEvent, MessagingState> {
  MessagingBloc(this.firestore, this.userRepo);
  FirestoreRepo firestore;
  UserRepository userRepo;
  // StreamSubscription streamSubscription;
  @override
  MessagingState get initialState => MessagingInitial();

  @override
  Stream<MessagingState> mapEventToState(
    MessagingEvent event,
  ) async* {
    if (event is SendMessages) {
      String senderEmail = await userRepo.getUser();
      var id = (state as Complete).selectedId;
      firestore.sendMessage(
          event.content, senderEmail, (state as Complete).sideChat[id]['idTo']);
    }
    if (event is Initialize) {
      var self = await userRepo.getUser();
      var recent = await firestore.getRecent(self);
      var newList = recent.map((e) {
        if (e['participants1'] == e['participants2']) {
          return null;
        }
        if (e['participants1'] == self) {
          return {'idTo': e['participants2']};
        } else if (e['participants2'] == self) {
          return {'idTo': e['participants1']};
        }
        return null;
      }).toList();
      List<Map> data1 = [
        {
          'idTo': await userRepo.getUser(),
          // 'isActive': true,
        },
      ];
      List data0 = ['Hello mfs'];
      List newsideChat;
      if (newList[0] == null) {
        print(newList.removeAt(0));
      }
      newsideChat = data1 + newList;
      // print(newsideChat);
      yield Complete(messages: data0, sideChat: newsideChat, selectedId: 0);
    }
    // if (event is AddSidebar) {}
    if (event is ShowMessages) {
      int loop = 0;
      int selectId = 0;
      bool exist = false;
      List newList = (state as Complete).sideChat;
      newList.forEach((element) {
        if (element['idTo'] == event.idTo) {
          exist = true;
          selectId = loop;
        }
        loop++;
      });
      if (exist) {
        yield Complete(
            messages: (state as Complete).messages,
            sideChat: newList,
            selectedId: selectId);
      } else {
        List<Map> data = [
          {'idTo': event.idTo}
        ];
        yield Complete(
            messages: (state as Complete).messages,
            sideChat: (state as Complete).sideChat + data,
            selectedId: (state as Complete).sideChat.length);
        //  _mapShowMessagestoState(event, state, newList);
      }
    }
  }

  // Stream _mapShowMessagestoState(
  //     ShowMessages event, Complete state, List list) async* {
  //   streamSubscription?.cancel();
  //   streamSubscription = firestore
  //       .getMessage(await userRepo.getUser(), event.idTo)
  //       .listen((event) {
  //     add(ShowM
  //       // Complete(
  //       //   messages: event,
  //       //   sideChat: state.sideChat,
  //       //   selectedId: state.sideChat.length - 1)
  //         );
  //   });
  // }
}
