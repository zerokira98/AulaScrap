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
  final int id;
  OpenCard(this.id);
  @override
  List<Object> get props => [id];
}

class HideCard extends CardlistEvent {
  final int id;
  HideCard(this.id);
  @override
  List<Object> get props => [id];
}

class ChangeFilter extends CardlistEvent {
  final int id;
  ChangeFilter(this.id);
  @override
  List<Object> get props => [id];
}
