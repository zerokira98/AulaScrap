import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'cardlist_event.dart';
part 'cardlist_state.dart';

class CardlistBloc extends Bloc<CardlistEvent, CardlistState> {
  List<Map> data = [];
  CardlistBloc() : super(CardlistInitial());

  @override
  Stream<CardlistState> mapEventToState(
    CardlistEvent event,
  ) async* {
    // print('here');

    if (state is CardlistInitial) {
      // yield Loading();
      if (event is LoadData) {
        for (var i = 0; i < event.sum; i++) {
          data.add({'close': true, 'hidden': false, 'id': i});
        }
        yield Loaded(data, 0);
      }
    }
    if (event is ChangeFilter) {
      yield* _mapChangeFilter(event.id);
    }
    if (event is HideCard) {
      yield* _mapCardHide(event.id);
    }
    if (event is OpenCard) {
      yield* _mapCardMenu(event.id);
      // yield Loading();

    }
  }

  Stream<CardlistState> _mapChangeFilter(int id) async* {
    // yield Loading();
    // var cstate = (state as Loaded);

    List<Map> filtered = [];
    if (id == 5) {
      for (var v in data) {
        if (v['hidden']) {
          filtered.add(v);
        }
      }
    } else {
      for (var v in data) {
        if (!v['hidden']) {
          filtered.add(v);
        }
      }
    }
    yield (state as Loaded).changeFilter(filtered, id);
    // yield Loaded((state as Loaded).data, ind);
  }

  Stream<CardlistState> _mapCardHide(int id) async* {
    // yield Loading();
    // List newData = (state as Loaded).data;
    data.forEach((element) {
      if (element['id'] == id) {
        element['hidden'] = !element['hidden'];
        element['close'] = !element['close'];
      }
    });

    // if (state is Loaded) {
    //   for (var i = 0; i < newData.length; i++) {
    //     if (i != ind) {
    //       newData[i]['hide'] = true;
    //     }
    //   }
    print(data);
    add(ChangeFilter(id));
    // yield (state as Loaded).changeFilter(data, (state as Loaded).currentFilter);
    // yield (state as Loaded).hideCard(newData);
    // }
  }

  Stream<CardlistState> _mapCardMenu(int id) async* {
    yield Loading();
    List<Map> newData = (state as Loaded).data;
    newData.forEach((element) {
      if (element['id'] == id) {
        element['close'] = !element['close'];
      } else {
        element['close'] = true;
      }
    });
    // newData[id]['close'] = !newData[id]['close'];
    // if (state is Loaded) {
    //   for (var i in newData) {
    //     if (i != id) {
    //       newData[i]['close'] = true;
    //     }
    //   }
    // print(newData);
    yield Loaded(newData, (state as Loaded).currentFilter);
  }
}
