import 'package:flutter/widgets.dart';

import 'package:flutter/material.dart';

class Utils {
  static List<T> modelBuilder<M, T>(
          List<M> models, T Function(int index, M model) builder) =>
      models
          .asMap()
          .map<int, T>((index, model) => MapEntry(index, builder(index, model)))
          .values
          .toList();
}

Future pushToPage(BuildContext context, Widget widget) async {
  await Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => widget),
  );
}

Future pushAndReplaceToPage(BuildContext context, Widget widget) async {
  await Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (_) => widget),
  );
}

Future popAllandPush(BuildContext context, Widget widget) async {
  await Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (BuildContext context) => widget),
      ModalRoute.withName('/'));
}

// ignore: constant_identifier_names
//const String BASE_URL = "http://192.168.110.105:8088/api/";
//const String BASE_URL = "http://vmw-axreporting:8088/api/";
const String ENTORNO = "dev";
//const String ENTORNO = "Pro"; // desarrollo

//azure

const String BASE_URL_ = "https://thinktextilwebapi.azurewebsites.net/api/";
const String BASE_URL = "https://10.0.2.2:7293/api/";

const String VERSION = 'v: 0.07';
