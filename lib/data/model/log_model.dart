class LogModel {
  late final int? id;
  final String mocacota;
  final String posicion;
  final String matricula;
  late final String usuario;
  late final String? fecha;

  /* final String nombre;
  final int? rolId;
  final String? rol; */

  LogModel(
      {required this.mocacota,
      required this.posicion,
      required this.matricula,
      required this.usuario});

  factory LogModel.fromJson(Map<String, dynamic> json) {
    return LogModel(
      mocacota: json['MOCACOTA'],
      posicion: json['POSICION'],
      matricula: json['MATRICULA'],
      usuario: json['USUARIO'],

      /*    nombre: json['nombre'],
      rol: json['rol'],
      rolId: json['rolId'], */
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mocacota'] = mocacota;
    data['posicion'] = posicion;
    data['matricula'] = matricula;
    data['usuario'] = usuario;
    data['id'] = 0;
    data['fecha'] = "2022-09-23T07:34:15.276Z";

    /*  data['nombre'] = nombre;
    data['rol'] = rol;
 */
    return data;
  }
}
