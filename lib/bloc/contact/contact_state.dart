part of 'contact_bloc.dart';

abstract class ContactState extends Equatable {
  const ContactState();
}

class ContactInitial extends ContactState {
  @override
  List<Object> get props => [];
}

class Loaded extends ContactState {
  Loaded({this.data});
  final List data;
  @override
  List<Object> get props => data;
}
