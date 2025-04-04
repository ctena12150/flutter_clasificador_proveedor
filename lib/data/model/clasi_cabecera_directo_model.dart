class ClasiCabeceraDirectoModel {
  final String nombre;
  final String usuario;
  final int idCabecera;
  final String fecha;

  /* final String nombre;
  final int? rolId;
  final String? rol; */

  ClasiCabeceraDirectoModel({
    required this.nombre,
    required this.usuario,
    required this.idCabecera,
    required this.fecha,
  });

  factory ClasiCabeceraDirectoModel.fromJson(Map<String, dynamic> json) {
    return ClasiCabeceraDirectoModel(
      nombre: json['nombre'],
      usuario: json['usuario'],
      idCabecera: json['idCabecera'],
      fecha: json['fecha'],

      /*    nombre: json['nombre'],
      rol: json['rol'],
      rolId: json['rolId'], */
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nombre'] = nombre;
    data['usuario'] = usuario;
    data['idCabecera'] = idCabecera;
    data['fecha'] = fecha;

    return data;
  }
}
