class ClasiModel {
  final String mocacota;
  final String posicion;

  /* final String nombre;
  final int? rolId;
  final String? rol; */

  ClasiModel({
    required this.mocacota,
    required this.posicion,
  });

  factory ClasiModel.fromJson(Map<String, dynamic> json) {
    return ClasiModel(
      mocacota: json['mocacota'],
      posicion: json['posicion'],

      /*    nombre: json['nombre'],
      rol: json['rol'],
      rolId: json['rolId'], */
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mocacota'] = mocacota;
    data['posicion'] = posicion;

    return data;
  }
}
