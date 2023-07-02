import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../constants.dart';

class LoginScreenTopImage extends StatelessWidget {
  const LoginScreenTopImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "LOGIN",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: defaultPadding * 1),
        Row(
          children: [
            const Spacer(),
            Expanded(
              flex: 4,
              child: Image.asset(
                  "assets/icons/logo_think.jpg"), // SvgPicture.asset("assets/icons/logo-think.svg"),
            ),
            const Spacer(),
          ],
        ),
        SizedBox(height: defaultPadding * 1),
      ],
    );
  }
}
