import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'cardlist_event.dart';
part 'cardlist_state.dart';

class CardlistBloc extends Bloc<CardlistEvent, CardlistState> {
  @override
  CardlistState get initialState => CardlistInitial();

  @override
  Stream<CardlistState> mapEventToState(
    CardlistEvent event,
  ) async* {
    // print('here');

    if (state is CardlistInitial) {
      // yield Loading();
      if (event is LoadData) {
        List<bool> data = [];
        for (var i = 0; i < event.sum; i++) {
          data.add(true);
        }
        yield Loaded(data);
      }
    }

    if (event is OpenCard) {
      yield* _mapCardMenu(event.index);
      // yield Loading();

    }
  }

  Stream<CardlistState> _mapCardMenu(int ind) async* {
    yield Loading();
    List newData = (state as Loaded).data;
    newData[ind] = !newData[ind];
    if (state is Loaded) {
      for (var i = 0; i < newData.length; i++) {
        if (i != ind) {
          newData[i] = true;
        }
      }
      // print(newData);
      yield Loaded(newData);
    }
  }
}
