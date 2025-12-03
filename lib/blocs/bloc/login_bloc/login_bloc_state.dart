part of 'login_bloc.dart';

abstract class LoginBlocState extends Equatable {
  const LoginBlocState();
}

class LoginBlocInitial extends LoginBlocState {
  @override
  List<Object> get props => [];
}

class DoLoginState extends LoginBlocState {
  final Map response;
  const DoLoginState({required this.response});
  @override
  List<Object> get props => [response];
}

class ErrorInLoginState extends LoginBlocState {
  final String response;
  const ErrorInLoginState({required this.response});
  @override
  List<Object> get props => [response];
}

class TokenErrorInLoginState extends LoginBlocState {
  const TokenErrorInLoginState();
  @override
  List<Object> get props => [];
}

class LoadingLoginState extends LoginBlocState {
  LoadingLoginState();
  @override
  List<Object> get props => [];
}
