part of 'cardlist_bloc.dart';

abstract class CardlistState extends Equatable {
  const CardlistState();
  @override
  List<Object> get props => [];
}

class CardlistInitial extends CardlistState {}

class Loaded extends CardlistState {
  final double cardSize = 140.0;
  final List<bool> data;
  Loaded(this.data);
  @override
  List<Object> get props => [data];
}

class Loading extends CardlistState {}

class Error extends CardlistState {}
