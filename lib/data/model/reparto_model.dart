class RepartoModel {
  final String? id_reparto;

  RepartoModel({this.id_reparto});

  factory RepartoModel.fromJson(Map<String, dynamic> json) {
    return RepartoModel(id_reparto: json['id_reparto']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id_reparto'] = id_reparto;

    return data;
  }
}
