class RepartoPosicionModel {
  final String? mocacota;
  final String? posicion;
  final String? id_reparto;
  final int? id;
  final int? pendiente;

  RepartoPosicionModel(
      {this.mocacota, this.posicion, this.id_reparto, this.id, this.pendiente});

  factory RepartoPosicionModel.fromJson(Map<String, dynamic> json) {
    return RepartoPosicionModel(
      mocacota: json['mocacota'],
      posicion: json['posicion'],
      id_reparto: json['id_reparto'],
      id: json['id'],
      pendiente: json['pendiente'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mocacota'] = mocacota;
    data['posicion'] = posicion;
    data['id_reparto'] = id_reparto;
    data['id'] = id;
    data['pendiente'] = pendiente;

    return data;
  }
}
