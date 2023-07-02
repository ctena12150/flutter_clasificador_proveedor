import 'package:flutter/material.dart';
import 'package:flutter_clasificacion_proveedor/components/background.dart';
import 'package:flutter_clasificacion_proveedor/presentation/screens/login/componentes/login_form.dart';
import 'package:flutter_clasificacion_proveedor/presentation/screens/login/componentes/login_screen_top_image.dart';
import 'package:flutter_clasificacion_proveedor/responsive.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Background(
      child: SingleChildScrollView(
        child: Responsive(
          mobile: const MobileLoginScreen(),
          tablet: Row(
            children: [
              const Expanded(
                child: LoginScreenTopImage(),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 350,
                      child: LoginForm(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          desktop: Row(
            children: [
              const Expanded(
                child: LoginScreenTopImage(),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 450,
                      child: LoginForm(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MobileLoginScreen extends StatelessWidget {
  const MobileLoginScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        //const LoginScreenTopImage(),
        Row(
          children: [
            const Spacer(),
            Expanded(
              flex: 4,
              child: LoginForm(),
            ),
            const Spacer(),
          ],
        ),
      ],
    );
  }
}
