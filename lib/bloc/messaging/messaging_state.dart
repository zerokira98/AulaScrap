part of 'messaging_bloc.dart';

abstract class MessagingState extends Equatable {
  const MessagingState();
  @override
  List<Object> get props => [];
}

class MessagingInitial extends MessagingState {
  @override
  List<Object> get props => [];
}

// class ChangedMassageScreen extends MessagingState {}

class Loading extends MessagingState {}

class Complete extends MessagingState {
  final List<Map> sideChat;
  // {
  //   'idTo':'email@email.com',
  //   'isActive':false,
  // }
  final List messages;
  final int selectedId;
  Complete({this.messages, this.sideChat, this.selectedId});

  @override
  List<Object> get props => [messages, sideChat, selectedId];
}
