class ClasiModelReparto {
  final String mocacota;
  final String posicion;
  final String id_reparto;
  final int pendiente;

  /* final String nombre;
  final int? rolId;
  final String? rol; */

  ClasiModelReparto({
    required this.mocacota,
    required this.posicion,
    required this.id_reparto,
    required this.pendiente,
  });

  factory ClasiModelReparto.fromJson(Map<String, dynamic> json) {
    return ClasiModelReparto(
      mocacota: json['mocacota'],
      posicion: json['posicion'],
      id_reparto: json['id_reparto'],
      pendiente: json['pendiente'],

      /*    nombre: json['nombre'],
      rol: json['rol'],
      rolId: json['rolId'], */
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mocacota'] = mocacota;
    data['posicion'] = posicion;
    data['id_reparto'] = id_reparto;
    data['pendiente'] = pendiente;

    return data;
  }
}
