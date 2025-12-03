part of 'login_bloc.dart';

abstract class LoginBlocEvent extends Equatable {
  const LoginBlocEvent();
}

class DoLoginEvent extends LoginBlocEvent {
  final String token;
  final String email;
  final String response;
  const DoLoginEvent({required this.token, required this.email, required this.response});
  @override
  List<Object> get props => [token, email, response];
}
