import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/model/user_model.dart';
import '../../../utils/navigation_utils.dart';
import 'login_state.dart';
import 'package:http/http.dart' as http;

class LoginCubit extends Cubit<LoginState> {
  //final TextEditingController nameController;

  final TextEditingController userController;

  final TextEditingController passwordController;

  final GlobalKey<FormState> formKey;

  bool isLoginFailed = false;
  bool isLoginFailed2 = false;
  String error = '';

  bool isLoading = false;

  bool isLockOpen = false;

  LoginCubit(this.formKey, this.userController, this.passwordController)
      : super(LoginInitial());

  List<UserModel> parsePickingRouters(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<UserModel>((json) => UserModel.fromJson(json)).toList();
  }

  Future<void> postUserModel() async {
    try {
      if (1 == 1) {
        var connectivityResult = await (Connectivity().checkConnectivity());
        if (connectivityResult == ConnectivityResult.none) {
          if (isLoginFailed) {
            isLoginFailed2 = true;
            isLoginFailed = false;
            emit(LoginValidateState2(
                isValidate: isLoginFailed, error: "Sin conexión"));
          } else {
            isLoginFailed = true;
            isLoginFailed2 = false;
            emit(LoginValidateState(
                isValidate: isLoginFailed, error: "sin conexión"));
          }
          return;
          // I am connected to a mobile network.
        }

        //   emit(const LoginLoadingState(true));

        String base = "${BASE_URL}Usuario/Usuario";
        String usuario = userController.text.trim();
        if (usuario.isEmpty) {
          if (isLoginFailed) {
            isLoginFailed2 = true;
            isLoginFailed = false;
            emit(LoginValidateState2(
                isValidate: isLoginFailed,
                error: "el usuario no está informado"));
          } else {
            isLoginFailed = true;
            isLoginFailed2 = false;
            emit(LoginValidateState(
                isValidate: isLoginFailed,
                error: "el usuario no está informado"));
          }
          return;
        }

        String pass = passwordController.text.trim();
        base += "/$usuario";
        base += "/$pass";

        var url = Uri.parse(base);
        final response = await http.get(url, headers: {
          'Content-Type': 'application/json',
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Credentials': 'true',
          'Access-Control-Allow-Headers': 'Content-Type',
          'Access-Control-Allow-Methods': 'GET,PUT,POST,DELETE'
        });
        if (response.statusCode == 200) {
          final parsed = json.decode(response.body) as List;
          if (parsed.isEmpty) {
            if (isLoginFailed) {
              isLoginFailed2 = true;
              isLoginFailed = false;
              emit(LoginValidateState2(
                  isValidate: isLoginFailed,
                  error: "el usuario o la contraseña no son correctas"));
            } else {
              isLoginFailed = true;
              isLoginFailed2 = false;
              emit(LoginValidateState(
                  isValidate: isLoginFailed,
                  error: "el usuario o la contraseña no son correctas"));
            }
            return;
          }
          var retorno = parsed[0];
          final data = UserModel.fromJson(retorno);

          emit(LoginComplete(data));
        } else {
          emit(LoginValidateState(
              isValidate: isLoginFailed,
              error: response.statusCode.toString()));
        }

        UserModel user = UserModel(usuarioId: usuario);
        emit(LoginComplete(user));
      } else {
        if (isLoginFailed) {
          isLoginFailed2 = true;
          isLoginFailed = false;
          emit(LoginValidateState2(
              isValidate: isLoginFailed, error: "error sin validad"));
        } else {
          isLoginFailed = true;
          isLoginFailed2 = false;
          emit(LoginValidateState(
              isValidate: isLoginFailed, error: "error sin validad"));
        }
      }
    } catch (exception) {
      emit(LoginValidateState(
          isValidate: isLoginFailed, error: exception.toString()));
    }
  }

  void changeLockView() {
    isLockOpen = !isLockOpen;
    emit(LoginLockState(isLockOpen));
  }
}
