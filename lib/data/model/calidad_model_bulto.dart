class CalidadModelBulto {
  String modelo;
  String calidad;
  String talla;
  String color;

  int cantidad;
  int cantidadLeida;
  String mocaco;

/*

   public string modelo { get; set; }  =string.Empty;
   public string calidad { get; set; } =string.Empty;
   public string color {  get; set; } =string.Empty;   
   public string talla {  get; set; } =string.Empty;   
   public int cantidad {  get; set; } =0;    
   public int cantidadLeida {  get; set; } =0; 
*/
  CalidadModelBulto({
    required this.modelo,
    required this.calidad,
    required this.talla,
    required this.color,
    required this.cantidad,
    required this.cantidadLeida,
    required this.mocaco,
  });

  factory CalidadModelBulto.fromJson(Map<String, dynamic> json) {
    return CalidadModelBulto(
      modelo: json['modelo'],
      calidad: json['calidad'],
      talla: json['talla'],
      color: json['color'],
      cantidad: json['cantidad'],
      cantidadLeida: json['cantidadLeida'],
      mocaco: json['mocaco'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['modelo'] = modelo;
    data['calidad'] = calidad;
    data['talla'] = talla;
    data['color'] = color;
    data['cantidad'] = cantidad;
    data['cantidadLeida'] = cantidadLeida;
    data['mocaco'] = mocaco;

    return data;
  }
}
