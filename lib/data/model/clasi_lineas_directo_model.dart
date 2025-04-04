class ClasiLineaDirectoModel {
  final int idLinea;
  final String item;
  final int posicion;
  final int idCabecera;

  ClasiLineaDirectoModel({
    required this.idLinea,
    required this.item,
    required this.posicion,
    required this.idCabecera,
  });

  factory ClasiLineaDirectoModel.fromJson(Map<String, dynamic> json) {
    return ClasiLineaDirectoModel(
      idLinea: json['idLinea'],
      item: json['item'],
      posicion: json['posicion'],
      idCabecera: json['idCabecera'],

      /*    nombre: json['nombre'],
      rol: json['rol'],
      rolId: json['rolId'], */
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idLinea'] = idLinea;
    data['item'] = item;
    data['posicion'] = posicion;
    data['idCabecera'] = idCabecera;
    return data;
  }
}
