part of 'cardlist_bloc.dart';

abstract class CardlistState extends Equatable {
  const CardlistState();
  @override
  List<Object> get props => [];
}

class CardlistInitial extends CardlistState {}

class Loaded extends CardlistState {
  final int currentFilter;
  final double cardSize = 132.0;
  final List<Map> data;
  const Loaded(this.data, this.currentFilter);
  Loaded changeFilter(List<Map> data, int intFilter) {
    return copy(data: data, currentFilter: intFilter);
  }

  Loaded hideCard(List data) {
    return copy(data: data);
  }

  Loaded changeMenu(List data) {
    return copy(data: data);
  }

  Loaded copy({List<Map> data, int currentFilter}) {
    return Loaded(data ?? this.data, currentFilter ?? this.currentFilter);
  }

  @override
  List<Object> get props =>
      [] + [currentFilter] + data.map((e) => e['close']).toList();

  @override
  String toString() {
    print(props);
    return super.toString();
  }
}

class Loading extends CardlistState {}

class Error extends CardlistState {}
