class UserModel {
  final String usuarioId;
  /* final String nombre;
  final int? rolId;
  final String? rol; */

  UserModel({
    required this.usuarioId,
    /*  required this.nombre,
    this.rolId,
    this.rol, */
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      usuarioId: json['usuarioId'],
      /*    nombre: json['nombre'],
      rol: json['rol'],
      rolId: json['rolId'], */
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['usuarioId'] = usuarioId;
    /*  data['nombre'] = nombre;
    data['rol'] = rol;
 */
    return data;
  }
}
