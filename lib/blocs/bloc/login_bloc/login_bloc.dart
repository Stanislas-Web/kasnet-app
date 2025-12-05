import 'dart:async';

import 'package:un/logics/logic_login.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'login_bloc_event.dart';
part 'login_bloc_state.dart';

class LoginBloc extends Bloc<LoginBlocEvent, LoginBlocState> {
  final LoginLogic? logicLogin;

  LoginBloc({this.logicLogin}) : super(LoginBlocInitial()) {
    on<DoLoginEvent>(_onDoLogin);
  }

  Future<void> _onDoLogin(DoLoginEvent event, Emitter<LoginBlocState> emit) async {
    emit(LoadingLoginState());
    print('🔵 DoLoginEvent reçu - Email: ${event.email}');
    try {
      await logicLogin!.login(token: event.token, email: event.email);
      emit(DoLoginState(response: {'message': 'Login successful'}));
    } catch (e) {
      print('🔴 Exception dans LoginBloc: $e');
      print('🔴 Type: ${e.runtimeType}');
      if (e is LoginFormatException || e == LoginFormatException) {
        emit(ErrorInLoginState(
            response: 'Error de comunicación')); // Error en el formato de envío
      } else if (e is LoginServerException || e == LoginServerException) {
        emit(ErrorInLoginState(response: 'Error en el servidor'));
      } else if (e is LoginForbiddenException || e == LoginForbiddenException) {
        emit(TokenErrorInLoginState());
      } else if (e is LoginGenericException) {
        emit(ErrorInLoginState(response: 'Ocurrió un error'));
      } else {
        emit(ErrorInLoginState(response: 'Ocurrió un error'));
      }
    }
  }
}
