import 'dart:convert';

import 'package:flutter_clasificacion_proveedor/data/model/borrar_bulto_calidad.dart';
import 'package:flutter_clasificacion_proveedor/data/model/calidad_detalle_model.dart';
import 'package:flutter_clasificacion_proveedor/data/model/calidad_model.dart';
import 'package:flutter_clasificacion_proveedor/data/model/calidad_model_bulto.dart';
import 'package:flutter_clasificacion_proveedor/data/model/clasi_cabecera_directo_model.dart';
import 'package:flutter_clasificacion_proveedor/data/model/clasi_lineas_directo_model.dart';
import 'package:flutter_clasificacion_proveedor/data/model/lod_model_reparto.dart';
import 'package:flutter_clasificacion_proveedor/data/model/log_calidad.dart';
import 'package:flutter_clasificacion_proveedor/data/model/log_model.dart';
import 'package:flutter_clasificacion_proveedor/data/model/reparto_model.dart';
import 'package:flutter_clasificacion_proveedor/data/model/reparto_posicion_model.dart';
import 'package:flutter_clasificacion_proveedor/utils/navigation_utils.dart';
import 'package:http/http.dart' as http;

class Service {
  Future<String> CerrarClasificacionDirecta(int idCabecera) async {
    String base = "${BASE_URL}Clasificacion/CerrarClasificacionDirecta";

    base += "/$idCabecera";

    var url = Uri.parse(base);

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Credentials': 'true',
          'Access-Control-Allow-Headers': 'Content-Type',
          'Access-Control-Allow-Methods': 'GET,PUT,POST,DELETE'
        },
      );

      if (response.statusCode == 200) {
        // final parsed = json.decode(response.body) as List;

        return "OK";
      } else {
        return "Error ${response.statusCode}";
      }
    } catch (exception) {
      return exception.toString();
    }
  }

  Future<List<ClasiLineaDirectoModel>> saveLogLineDirecto(
      ClasiLineaDirectoModel lineas) async {
    String base = "${BASE_URL}Clasificacion/saveLogLineDirecto";

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
        if (response.body == "[]") return [];

        final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
        return parsed
            .map<ClasiLineaDirectoModel>(
                (json) => ClasiLineaDirectoModel.fromJson(json))
            .toList();
      } else {
        throw Exception('Error salvar los datos');
      }
    } catch (exception) {
      throw Exception('Error $exception');
    }
  }

  Future<String> getClasificadorCabeceraDirecto(String usuario) async {
    String base =
        "${BASE_URL}Clasificacion/getClasificadorCabeceraDirecto?usuario=";

    base += usuario;

    var url = Uri.parse(base);

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Credentials': 'true',
          'Access-Control-Allow-Headers': 'Content-Type',
          'Access-Control-Allow-Methods': 'GET,PUT,POST,DELETE'
        },
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Error salvar los datos');
      }
    } catch (exception) {
      throw Exception('Error $exception');
    }
  }

  Future<List<ClasiCabeceraDirectoModel>> saveHeaderDirect(
      String nombre, String usuario) async {
    String base = "${BASE_URL}Clasificacion/saveHeaderDirect";
    ClasiCabeceraDirectoModel clasiCabeceraDirectoModel =
        ClasiCabeceraDirectoModel(
            nombre: nombre, usuario: usuario, idCabecera: 0, fecha: "");

    final body = jsonEncode(clasiCabeceraDirectoModel);
    var url = Uri.parse(base);

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
      if (response.body == "[]") return [];

      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      return parsed
          .map<ClasiCabeceraDirectoModel>(
              (json) => ClasiCabeceraDirectoModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Error salvar los datos');
    }
  }

  Future<int> borrarBultoCalidadDiferencias(
      BorrarBultoCalidaModel linea) async {
    String base = "${BASE_URL}Calidad/DeleteBultoCalidadDiferencias";

    var data = linea.toJson();
    // Map<String, dynamic> data = partesTrabajoLineaModel.toJson();

    final body = jsonEncode(data);
    var url = Uri.parse(base);

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
      return 0;
    } else {
      throw Exception('Error salvar los datos');
    }
  }

  Future<int> borrarBultoCalidad(BorrarBultoCalidaModel linea) async {
    String base = "${BASE_URL}Calidad/DeleteBultoCalidad";

    var data = linea.toJson();
    // Map<String, dynamic> data = partesTrabajoLineaModel.toJson();

    final body = jsonEncode(data);
    var url = Uri.parse(base);

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
      return 0;
    } else {
      throw Exception('Error salvar los datos');
    }
  }

  Future<String> cerrarRevisionDiferencias(String nombre) async {
    String base = "${BASE_URL}Calidad/CerrarRevisionDiferencias";

    base += "/$nombre";

    var url = Uri.parse(base);

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Credentials': 'true',
          'Access-Control-Allow-Headers': 'Content-Type',
          'Access-Control-Allow-Methods': 'GET,PUT,POST,DELETE'
        },
      );

      if (response.statusCode == 200) {
        // final parsed = json.decode(response.body) as List;

        return "OK";
      } else {
        return "Error ${response.statusCode}";
      }
    } catch (exception) {
      return exception.toString();
    }
  }

  Future<String> enviarDiferencias(String nombre) async {
    String base = "${BASE_URL}Calidad/EnviarDiferencias";

    base += "/$nombre";

    var url = Uri.parse(base);

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Credentials': 'true',
          'Access-Control-Allow-Headers': 'Content-Type',
          'Access-Control-Allow-Methods': 'GET,PUT,POST,DELETE'
        },
      );

      if (response.statusCode == 200) {
        final parsed = json.decode(response.body) as List;

        return "OK";
      } else {
        return "Error ${response.statusCode}";
      }
    } catch (exception) {
      return exception.toString();
    }
  }

  Future<String> cerrarRevision(String nombre) async {
    String base = "${BASE_URL}Calidad/CerrarRevision";

    base += "/$nombre";

    var url = Uri.parse(base);

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Credentials': 'true',
          'Access-Control-Allow-Headers': 'Content-Type',
          'Access-Control-Allow-Methods': 'GET,PUT,POST,DELETE'
        },
      );

      if (response.statusCode == 200) {
        final parsed = json.decode(response.body) as List;

        return "OK";
      } else {
        return "Error ${response.statusCode}";
      }
    } catch (exception) {
      return exception.toString();
    }
  }

  Future<List<CalidadDetalleModel>> resetMocacoCalidadDiferencias(
      LogCalidaModel linea) async {
    String base = "${BASE_URL}Calidad/ResetMocacoCalidadDiferencias";

    var data = linea.toJson();
    // Map<String, dynamic> data = partesTrabajoLineaModel.toJson();

    final body = jsonEncode(data);
    var url = Uri.parse(base);

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
      if (response.body == "[]") return [];
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      return parsed
          .map<CalidadDetalleModel>(
              (json) => CalidadDetalleModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Error salvar los datos');
    }
  }

  Future<List<CalidadModelBulto>> resetBultoCalidad(
      LogCalidaModel linea) async {
    String base = "${BASE_URL}Calidad/ResetBultoCalidad";

    var data = linea.toJson();
    // Map<String, dynamic> data = partesTrabajoLineaModel.toJson();

    final body = jsonEncode(data);
    var url = Uri.parse(base);

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
      if (response.body == "[]") return [];
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      return parsed
          .map<CalidadModelBulto>((json) => CalidadModelBulto.fromJson(json))
          .toList();
    } else {
      throw Exception('Error salvar los datos');
    }
  }

  Future<List<CalidadDetalleModel>> resetMocacoCalidad(
      LogCalidaModel linea) async {
    String base = "${BASE_URL}Calidad/ResetMocacoCalidad";

    var data = linea.toJson();
    // Map<String, dynamic> data = partesTrabajoLineaModel.toJson();

    final body = jsonEncode(data);
    var url = Uri.parse(base);

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
      if (response.body == "[]") return [];
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      return parsed
          .map<CalidadDetalleModel>(
              (json) => CalidadDetalleModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Error salvar los datos');
    }
  }

  Future<List<CalidadDetalleModel>> saveLogCalidadDiferencias(
      LogCalidaModel linea) async {
    String base = "${BASE_URL}Calidad/AddRevisionCalidadDiferencias";

    var data = linea.toJson();
    // Map<String, dynamic> data = partesTrabajoLineaModel.toJson();

    final body = jsonEncode(data);
    var url = Uri.parse(base);

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
      if (response.body == "[]") return [];
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      return parsed
          .map<CalidadDetalleModel>(
              (json) => CalidadDetalleModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Error salvar los datos');
    }
  }

  Future<List<CalidadDetalleModel>> saveLogCalidad(LogCalidaModel linea) async {
    String base = "${BASE_URL}Calidad/AddRevisionCalidad";

    var data = linea.toJson();
    // Map<String, dynamic> data = partesTrabajoLineaModel.toJson();

    final body = jsonEncode(data);
    var url = Uri.parse(base);

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
      if (response.body == "[]") return [];
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      return parsed
          .map<CalidadDetalleModel>(
              (json) => CalidadDetalleModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Error salvar los datos');
    }
  }

  Future<List<CalidadModel>> fetchRevisionCalidadPendientesDiferencias() async {
    String base = "${BASE_URL}Calidad/GetRevisionCalidadPendientesDiferencias";

    final response = await http.get(Uri.parse(base));

    if (response.statusCode == 200) {
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      return parsed
          .map<CalidadModel>((json) => CalidadModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Error Rbúsqueda de calidad');
    }
  }

  Future<List<CalidadModelBulto>> fetchRevisionCalidadPendientesByBultos(
      nombre, skuBulto) async {
    String base =
        "${BASE_URL}Calidad/GetRevisionCalidadPendientesByBulto?nombre=$nombre&skuBulto=$skuBulto";

    final response = await http.get(Uri.parse(base));

    if (response.statusCode == 200) {
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      return parsed
          .map<CalidadModelBulto>((json) => CalidadModelBulto.fromJson(json))
          .toList();
    } else {
      throw Exception('Error búsqueda de bulto');
    }
  }

  Future<List<CalidadModel>> fetchRevisionCalidadPendientes() async {
    String base = "${BASE_URL}Calidad/GetRevisionCalidadPendientes";

    final response = await http.get(Uri.parse(base));

    if (response.statusCode == 200) {
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      return parsed
          .map<CalidadModel>((json) => CalidadModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Error Rbúsqueda de calidad');
    }
  }

  Future<String> saveLog(LogModel lineas) async {
    String base = "${BASE_URL}Clasificacion/AddClasiLogNewProcedure";

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
        if (response.body.toUpperCase() == "OK") {
          return "OK";
        } else {
          return "Error  ${response.body}";
        }
      } else {
        return "Error ${response.statusCode}";
      }
    } catch (exception) {
      return exception.toString();
    }
  }

  Future<List<RepartoModel>> fetchRepartos(String usuario) async {
    String base =
        "${BASE_URL}Clasificacion/GetRepartosProveedorNew?usuario=$usuario";

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
      String mocacota, String idReparto, String usuario) async {
    String base =
        "${BASE_URL}Clasificacion/ClasiPosicionRepartoProveedorNew?mocacota=$mocacota&id_reparto=$idReparto&usuario=$usuario";

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
