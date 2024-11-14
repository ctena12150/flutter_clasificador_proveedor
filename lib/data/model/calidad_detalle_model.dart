class CalidadDetalleModel {
  final String bulto;
  final String mocaco;
  final int bultos;
  final int bultosPendientes;

  CalidadDetalleModel({
    required this.bulto,
    required this.mocaco,
    required this.bultos,
    required this.bultosPendientes,
  });

  factory CalidadDetalleModel.fromJson(Map<String, dynamic> json) {
    return CalidadDetalleModel(
      bulto: json['bulto'],
      mocaco: json['mocaco'],
      bultos: json['bultos'],
      bultosPendientes: json['bultosPendientes'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['bulto'] = bulto;
    data['mocaco'] = mocaco;
    data['bultos'] = bultos;
    data['bultosPendientes'] = bultosPendientes;

    return data;
  }
}
