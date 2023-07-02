class LogModelReparto {
  late final int? id;
  final String mocacota;
  final String posicion;
  final String matricula;
  late final String usuario;
  late final String? fecha;
  late final String id_reparto;

  /* final String nombre;
  final int? rolId;
  final String? rol; */

  LogModelReparto(
      {required this.mocacota,
      required this.posicion,
      required this.matricula,
      required this.usuario,
      required this.id_reparto,
      required this.id});

  factory LogModelReparto.fromJson(Map<String, dynamic> json) {
    return LogModelReparto(
      mocacota: json['MOCACOTA'],
      posicion: json['POSICION'],
      matricula: json['MATRICULA'],
      usuario: json['USUARIO'],
      id_reparto: json['ID_REPARTO'],
      id: json['id'],
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
    data['id'] = id;
    data['fecha'] = "2022-09-23T07:34:15.276Z";
    data['id_reparto'] = id_reparto;

    /*  data['nombre'] = nombre;
    data['rol'] = rol;
 */
    return data;
  }
}
