import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clasificacion_proveedor/constants.dart';
import 'package:flutter_clasificacion_proveedor/presentation/bloc/logoin/login_cubit.dart';
import 'package:flutter_clasificacion_proveedor/presentation/bloc/logoin/login_state.dart';
import 'package:flutter_clasificacion_proveedor/presentation/dashboard/dashboard.dart';
import 'package:flutter_clasificacion_proveedor/presentation/dashboard/panel.dart';

// ignore: use_key_in_widget_constructors
class LoginForm extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController userController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(
        formKey,
        userController,
        passwordController,
      ),
      child: BlocConsumer<LoginCubit, LoginState>(listener: (context, state) {
        if (state is LoginComplete) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Panel(usuario: state.model)));
        } else if (state is LoginValidateState ||
            state is LoginValidateState2) {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.info,
            animType: AnimType.bottomSlide,
            title: 'Error',
            desc: state.error,

            // btnCancelOnPress: () {},
            btnOkOnPress: () {
              // Navigator.pop(context);
            },
          ).show();
        } else if (state is LoginLoadingState) {
          // Navigator.pop(context);
          //const CircularProgressIndicator();
        }
      }, builder: (context, state) {
        return (state is LoginLoadingState)
            ? const SizedBox(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(),
              )
            : Form(
                child: SingleChildScrollView(
                  reverse: true,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: userController,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        validator: (value) => (value ?? "").isNotEmpty
                            ? null
                            : "El nombre debe ser informado",
                        cursorColor: kPrimaryColor,
                        onSaved: (email) {},
                        decoration: const InputDecoration(
                          hintText: "Usuario",
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(defaultPadding),
                            child: Icon(Icons.person),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: defaultPadding),
                        child: TextFormField(
                          controller: passwordController,
                          textInputAction: TextInputAction.done,
                          obscureText: true,
                          validator: (value) => (value ?? "").isNotEmpty
                              ? null
                              : "La contraseña debe ser informada",
                          cursorColor: kPrimaryColor,
                          decoration: const InputDecoration(
                            hintText: "Contraseña",
                            prefixIcon: Padding(
                              padding: EdgeInsets.all(defaultPadding),
                              child: Icon(Icons.lock),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: defaultPadding),
                      Hero(
                        tag: "login_btn",
                        child: ElevatedButton(
                          onPressed: context.watch<LoginCubit>().isLoading
                              ? null
                              : () {
                                  context.read<LoginCubit>().postUserModel();
                                },
                          child: Text(
                            "Login".toUpperCase(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: defaultPadding),
                    ],
                  ),
                ),
              );
      }),
    );
  }
}
