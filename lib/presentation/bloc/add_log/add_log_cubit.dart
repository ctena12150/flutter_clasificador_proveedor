import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clasificacion_proveedor/data/model/clasi_model.dart';
import 'package:flutter_clasificacion_proveedor/data/model/log_model.dart';
import 'package:flutter_clasificacion_proveedor/presentation/bloc/add_log/add_log_state.dart';

import '../../../data/model/user_model.dart';
import '../../../utils/navigation_utils.dart';

import 'package:http/http.dart' as http;

class AddLogCubit extends Cubit<AddLogState> {
  //final TextEditingController nameController;

  bool isLoginFailed = false;
  bool isLoginFailed2 = false;
  String error = '';

  bool isLoading = false;

  bool isLockOpen = false;

  AddLogCubit() : super(const AddLogState.loading());

  List<ClasiModel> parsePickingRouters(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<ClasiModel>((json) => ClasiModel.fromJson(json)).toList();
  }

  Future<void> fetchPosicion(String sku) async {
    String base = "${BASE_URL}Clasificacion/ClasiPosicion/$sku";
    try {
      final response = await http.get(Uri.parse(base));

      if (response.statusCode == 200) {
        final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
        var items = parsed
            .map<ClasiModel>((json) => ClasiModel.fromJson(json))
            .toList();
        emit(AddLogState.success(items));
      } else {
        throw Exception('Error usuarios');
      }
    } catch (Exception) {
      emit(AddLogState.failure(Exception.toString()));
    }
  }

  Future<void> fetchPosiciones() async {
    String base = "${BASE_URL}Clasificacion/ClasiPosiciones/";
    try {
      emit(const AddLogState.loading());
      final response = await http.get(Uri.parse(base));

      if (response.statusCode == 200) {
        final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
        var items = parsed
            .map<ClasiModel>((json) => ClasiModel.fromJson(json))
            .toList();
        emit(AddLogState.success(items));
      } else {
        throw Exception('Error al recuperar los datos');
      }
    } catch (Exception) {
      emit(AddLogState.failure(Exception.toString()));
    }
  }
}
