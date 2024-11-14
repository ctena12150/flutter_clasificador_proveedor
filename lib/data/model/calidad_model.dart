class CalidadModel {
  final String descripcion;
  final int bultosLeidos;
  final int bultos;
  final int bultosPendientes;

  CalidadModel({
    required this.descripcion,
    required this.bultosLeidos,
    required this.bultos,
    required this.bultosPendientes,
  });

  factory CalidadModel.fromJson(Map<String, dynamic> json) {
    return CalidadModel(
      descripcion: json['descripcion'],
      bultosLeidos: json['bultosLeidos'],
      bultos: json['bultos'],
      bultosPendientes: json['bultosPendientes'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['descripcion'] = descripcion;
    data['bultosLeidos'] = bultosLeidos;
    data['bultos'] = bultos;
    data['bultosPendientes'] = bultosPendientes;

    return data;
  }
}
