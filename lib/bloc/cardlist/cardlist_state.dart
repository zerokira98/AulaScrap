part of 'cardlist_bloc.dart';

abstract class CardlistState extends Equatable {
  const CardlistState();
  @override
  List<Object> get props => [];
}

class CardlistInitial extends CardlistState {}

class Loaded extends CardlistState {
  final int currentFilter;
  final double cardSize = 140.0;
  final List<Map> data;
  const Loaded(this.data, this.currentFilter);
  Loaded changeFilter(int intFilter) {
    return copy(currentFilter: intFilter);
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
  List<Object> get props => [data, currentFilter];
}

class Loading extends CardlistState {}

class Error extends CardlistState {}
