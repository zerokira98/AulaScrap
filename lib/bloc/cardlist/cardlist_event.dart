part of 'cardlist_bloc.dart';

abstract class CardlistEvent extends Equatable {
  const CardlistEvent();
  @override
  List<Object> get props => [];
}

class LoadData extends CardlistEvent {
  final int sum;

  LoadData(this.sum);
  @override
  List<Object> get props => [sum];
}

class OpenCard extends CardlistEvent {
  final int index;
  OpenCard(this.index);
  @override
  List<Object> get props => [index];
}