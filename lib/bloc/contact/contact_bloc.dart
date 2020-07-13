import 'dart:async';

import 'package:aula/repository/firestore.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'contact_event.dart';
part 'contact_state.dart';

class ContactBloc extends Bloc<ContactEvent, ContactState> {
  List data;
  FirestoreRepo firestore;

  ContactBloc(this.firestore) : super(ContactInitial());
  @override
  Stream<ContactState> mapEventToState(
    ContactEvent event,
  ) async* {
    if (event is Initialize) {
      data = await firestore.getUsers();
      List newdata = data.map((e) {
        return {'email': e['email'], 'username': e['name'], 'pp': e['pp']};
        // print(e['email']);
        // return
      }).toList();
      print(newdata);
      yield Loaded(data: newdata);
    }
    if (event is Search) {
      List newdata = data.map<Map>((e) {
        if (e['email'].toString().split('@')[0].contains(event.query)) {
          return {'email': e['email'], 'username': e['name'], 'pp': e['pp']};
        } else
          return null;
      }).toList();
      newdata.removeWhere((value) => value == null);
      yield Loaded(data: newdata ?? []);
    }
  }
}
