import 'dart:convert';

import 'package:flutter_clasificacion_proveedor/data/model/lod_model_reparto.dart';
import 'package:flutter_clasificacion_proveedor/data/model/log_model.dart';
import 'package:flutter_clasificacion_proveedor/data/model/reparto_model.dart';
import 'package:flutter_clasificacion_proveedor/data/model/reparto_posicion_model.dart';
import 'package:flutter_clasificacion_proveedor/utils/navigation_utils.dart';
import 'package:http/http.dart' as http;

class Service {
  Future<String> saveLog(LogModel lineas) async {
    String base = "${BASE_URL}Clasificacion/AddClasiLogProveedor";

    var data = lineas.toJson();
    // Map<String, dynamic> data = partesTrabajoLineaModel.toJson();

    final body = jsonEncode(data);
    var url = Uri.parse(base);
    try {
      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Credentials': 'true',
            'Access-Control-Allow-Headers': 'Content-Type',
            'Access-Control-Allow-Methods': 'GET,PUT,POST,DELETE'
          },
          body: body);

      if (response.statusCode == 200) {
        // String reponse = response.body;

        return "OK";
      } else {
        return "Error ${response.statusCode}";
      }
    } catch (exception) {
      return exception.toString();
    }
  }

  Future<List<RepartoModel>> fetchRepartos() async {
    String base = "${BASE_URL}Clasificacion/GetRepartosProveedor";

    final response = await http.get(Uri.parse(base));

    if (response.statusCode == 200) {
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      return parsed
          .map<RepartoModel>((json) => RepartoModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Error Repartos');
    }
  }

  Future<RepartoPosicionModel> fetchPosicion(
      String mocacota, String idReparto) async {
    String base =
        "${BASE_URL}Clasificacion/ClasiPosicionRepartoProveedor?mocacota=$mocacota&id_reparto=$idReparto";

    final response = await http.get(Uri.parse(base));

    if (response.statusCode == 200) {
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      List<RepartoPosicionModel> resultado = parsed
          .map<RepartoPosicionModel>(
              (json) => RepartoPosicionModel.fromJson(json))
          .toList();
      if (resultado.isEmpty) {
        throw Exception('No se ha encontrado la posición');
      }

      return resultado[0];
    } else {
      throw Exception('Error Repartos');
    }
  }

  Future<String> saveLogReparto(LogModelReparto lineas) async {
    String base = "${BASE_URL}Clasificacion/AddClasiLogRepartoProveedor";

    var data = lineas.toJson();
    // Map<String, dynamic> data = partesTrabajoLineaModel.toJson();

    final body = jsonEncode(data);
    var url = Uri.parse(base);
    try {
      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Credentials': 'true',
            'Access-Control-Allow-Headers': 'Content-Type',
            'Access-Control-Allow-Methods': 'GET,PUT,POST,DELETE'
          },
          body: body);

      if (response.statusCode == 200) {
        // String reponse = response.body;

        return "OK";
      } else {
        return "Error ${response.statusCode}";
      }
    } catch (exception) {
      return exception.toString();
    }
  }
}
