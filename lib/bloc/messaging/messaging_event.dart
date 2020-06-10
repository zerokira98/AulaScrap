part of 'messaging_bloc.dart';

abstract class MessagingEvent extends Equatable {
  const MessagingEvent();
  @override
  List<Object> get props => [];
}

class Initialize extends MessagingEvent {}

class ShowMessages extends MessagingEvent {
  final idTo;
  ShowMessages({this.idTo});
  @override
  List<Object> get props => [idTo];
}
// class AddSidebar extends MessagingEvent {

// }

class SendMessages extends MessagingEvent {
  SendMessages({this.content});
  final String content;
  @override
  List<Object> get props => [content];
}
