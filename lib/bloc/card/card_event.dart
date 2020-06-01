part of 'card_bloc.dart';

abstract class CardEvent extends Equatable {
  const CardEvent();
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class Open extends CardEvent {}

class Close extends CardEvent {}
