class BorrarBultoCalidaModel {
  final String bulto;

  final String nombre;

  BorrarBultoCalidaModel({
    required this.bulto,
    required this.nombre,
  });

  factory BorrarBultoCalidaModel.fromJson(Map<String, dynamic> json) {
    return BorrarBultoCalidaModel(
      bulto: json['bulto'],
      nombre: json['nombre'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['bulto'] = bulto;
    data['nombre'] = nombre;

    return data;
  }
}
