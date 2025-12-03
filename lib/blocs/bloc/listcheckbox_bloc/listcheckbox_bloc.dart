import 'dart:async';

import 'package:un/models/days.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'listcheckbox_event.dart';
part 'listcheckbox_state.dart';

class ListcheckboxBloc extends Bloc<ListcheckboxEvent, ListcheckboxState> {
  ListcheckboxBloc() : super(ListcheckboxInitial()) {
    on<RepaintListCheckboxEvent>(_onRepaintListCheckbox);
  }

  Future<void> _onRepaintListCheckbox(RepaintListCheckboxEvent event, Emitter<ListcheckboxState> emit) async {
    emit(RepaintListCheckboxState(days: event.days));
  }
}
