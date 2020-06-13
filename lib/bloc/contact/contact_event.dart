part of 'contact_bloc.dart';

abstract class ContactEvent extends Equatable {
  const ContactEvent();
  @override
  List<Object> get props => [];
}

class Initialize extends ContactEvent {
  @override
  List<Object> get props => [];
}

class Search extends ContactEvent {
  final String query;
  Search(this.query);
  @override
  List<Object> get props => [query];
}
