import 'package:equatable/equatable.dart';
import 'package:flutter_clasificacion_proveedor/data/model/clasi_model.dart';
import 'package:flutter_clasificacion_proveedor/data/model/log_model.dart';

enum ListStatus { loading, success, failure }

class AddLogState extends Equatable {
  const AddLogState._({
    this.status = ListStatus.loading,
    this.items = const <ClasiModel>[],
    this.error = '',
  });

  const AddLogState.loading() : this._();

  const AddLogState.success(List<ClasiModel> items)
      : this._(status: ListStatus.success, items: items);

  const AddLogState.success2() : this._(status: ListStatus.success);

  const AddLogState.failure(String error)
      : this._(status: ListStatus.failure, error: error);

  final ListStatus status;
  final List<ClasiModel> items;
  final String error;

  @override
  List<Object> get props => [status, items];
}
