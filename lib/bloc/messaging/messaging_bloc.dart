import 'dart:async';

import 'package:aula/repository/firestore.dart';
import 'package:aula/repository/user_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

part 'messaging_event.dart';
part 'messaging_state.dart';

class MessagingBloc extends Bloc<MessagingEvent, MessagingState> {
  FirestoreRepo firestore;
  UserRepository userRepo;
  StreamSubscription streamSubscription;
  MessagingBloc(this.firestore, this.userRepo) : super(MessagingInitial());

  @override
  Future<void> close() {
    streamSubscription?.cancel();
    return super.close();
  }

  @override
  Stream<MessagingState> mapEventToState(
    MessagingEvent event,
  ) async* {
    if (event is UpdateMessage) {
      var msg = event.msg.docs.map<Map<dynamic, dynamic>>((e) {
        return {
          'content': e['content'],
          'sender': e['sender'],
        };
      }).toList();
      print(msg);
      yield Complete(
          messages: msg,
          sideChat: (state as Complete).sideChat,
          selectedId: (state as Complete).selectedId);
    }
    if (event is SendMessages) {
      String senderEmail = await userRepo.getUser();
      var id = (state as Complete).selectedId;
      firestore.sendMessage(
          event.content, senderEmail, (state as Complete).sideChat[id]['idTo']);
    }
    if (event is Initialize) {
      yield* _mapInitToState();
    }
    if (event is ShowMessages) {
      int loop = 0;
      int selectId = 0;
      bool exist = false;
      List newList = (state as Complete).sideChat;
      var self = await userRepo.getUser();
      streamSubscription?.cancel();
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

      streamSubscription =
          firestore.getMessage(self, event.idTo).listen((event) {
        add(UpdateMessage(event));
      });
    }
  }

  Stream<MessagingState> _mapInitToState() async* {
    print('here');
    streamSubscription?.cancel();
    var self = await userRepo.getUser();
    var recent = await firestore.getRecent(self);
    print(recent.length);

    List<Map> data1 = [
      {
        'idTo': await userRepo.getUser(),
        'pp': await userRepo.getUserPpUrl(),
      },
    ];
    List newsideChat = data1;
    if (recent.length != 0) {
      var newList = await Stream.fromIterable(recent).asyncMap((e) async {
        String pp;
        // Map data = {'pp': e['pp']};
        if (e['participants1'] == e['participants2']) {
          return null;
        }
        if (e['participants1'] == self) {
          pp = await firestore.getPpFromEmail(e['participants2']);
          return {
            'idTo': e['participants2'],
            'pp': pp,
          };
          // return data;
        } else if (e['participants2'] == self) {
          pp = await firestore.getPpFromEmail(e['participants1']);
          return {
            'idTo': e['participants1'],
            'pp': pp,
          };
          // return data;
        }
        return null;
      }).toList();
      newList.removeWhere((element) => element == null);
      print(newList);

      newsideChat = newsideChat + newList;
    }

    print(newsideChat);
    yield Complete(messages: [], sideChat: newsideChat, selectedId: 0);
    streamSubscription = firestore.getMessage(self, self).listen((event) {
      add(UpdateMessage(event));
    });
  }
}
