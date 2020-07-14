import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'cardlist_event.dart';
part 'cardlist_state.dart';

class CardlistBloc extends Bloc<CardlistEvent, CardlistState> {
  CardlistBloc() : super(CardlistInitial());

  @override
  Stream<CardlistState> mapEventToState(
    CardlistEvent event,
  ) async* {
    // print('here');

    if (state is CardlistInitial) {
      // yield Loading();
      if (event is LoadData) {
        List<Map> data = [];
        for (var i = 0; i < event.sum; i++) {
          data.add({'close': true, 'hidden': false});
        }
        yield Loaded(data, 0);
      }
    }
    if (event is ChangeFilter) {
      yield* _mapChangeFilter(event.index);
    }
    if (event is HideCard) {
      yield* _mapCardHide(event.index);
    }
    if (event is OpenCard) {
      yield* _mapCardMenu(event.index);
      // yield Loading();

    }
  }

  Stream<CardlistState> _mapChangeFilter(int ind) async* {
    // yield Loading();
    yield (state as Loaded).changeFilter(ind);
    // yield Loaded((state as Loaded).data, ind);
  }

  Stream<CardlistState> _mapCardHide(int ind) async* {
    yield Loading();
    List newData = (state as Loaded).data;

    newData[ind]['hidden'] = !newData[ind]['hidden'];
    newData[ind]['close'] = !newData[ind]['close'];

    // if (state is Loaded) {
    //   for (var i = 0; i < newData.length; i++) {
    //     if (i != ind) {
    //       newData[i]['hide'] = true;
    //     }
    //   }
    print(newData);
    yield (state as Loaded).hideCard(newData);
    // }
  }

  Stream<CardlistState> _mapCardMenu(int ind) async* {
    yield Loading();
    List newData = (state as Loaded).data;
    newData[ind]['close'] = !newData[ind]['close'];
    if (state is Loaded) {
      for (var i = 0; i < newData.length; i++) {
        if (i != ind) {
          newData[i]['close'] = true;
        }
      }
      // print(newData);
      yield Loaded(newData, (state as Loaded).currentFilter);
    }
  }
}
