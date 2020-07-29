import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'coursedata_event.dart';
part 'coursedata_state.dart';

class CoursedataBloc extends Bloc<CoursedataEvent, CoursedataState> {
  CoursedataBloc() : super(CoursedataInitial());

  @override
  Stream<CoursedataState> mapEventToState(
    CoursedataEvent event,
  ) async* {}
}
