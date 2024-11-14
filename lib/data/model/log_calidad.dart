class LogCalidaModel {
  final String bulto;
  final String mocaco;
  final String usuario;
  final String nombre;

  LogCalidaModel({
    required this.bulto,
    required this.mocaco,
    required this.usuario,
    required this.nombre,
  });

  factory LogCalidaModel.fromJson(Map<String, dynamic> json) {
    return LogCalidaModel(
      bulto: json['bulto'],
      mocaco: json['mocaco'],
      usuario: json['usuario'],
      nombre: json['nombre'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['bulto'] = bulto;
    data['mocaco'] = mocaco;
    data['usuario'] = usuario;
    data['nombre'] = nombre;

    return data;
  }
}
