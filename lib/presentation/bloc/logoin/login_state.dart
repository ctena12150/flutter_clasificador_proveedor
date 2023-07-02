//part of 'login_cubit.dart';

// ignore: import_of_legacy_library_into_null_safe

// ignore: import_of_legacy_library_into_null_safe
//import 'package:equatable/equatable.dart';
//import 'package:think_partes/data/model/user_model.dart';

import 'package:equatable/equatable.dart';

import '../../../data/model/user_model.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  get error => null;

  //get copyWith => null;
}

class LoginInitial extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginComplete extends LoginState {
  final UserModel model;

  const LoginComplete(this.model);
  @override
  List<Object> get props => [model];
}

class LoginValidateState extends LoginState {
  final bool isValidate;
  @override
  final String error;
  const LoginValidateState({required this.isValidate, required this.error});
  @override
  List<Object> get props => [isValidate, error];

  LoginValidateState copyWith({
    bool? isValidate,
    String? error,
  }) {
    return LoginValidateState(
      isValidate: isValidate ?? this.isValidate,
      error: error ?? this.error,
    );
  }
}

class LoginValidateState2 extends LoginState {
  final bool isValidate;
  @override
  final String error;
  const LoginValidateState2({required this.isValidate, required this.error});
  @override
  List<Object> get props => [isValidate, error];
}

class LoginLoadingState extends LoginState {
  final bool isLoading;
  const LoginLoadingState(this.isLoading);
  @override
  List<Object> get props => [isLoading];
}

class LoginLockState extends LoginState {
  final bool isLockOpen;
  const LoginLockState(this.isLockOpen);
  @override
  List<Object> get props => [isLockOpen];
}
