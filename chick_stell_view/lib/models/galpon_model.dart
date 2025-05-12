class Galpon {
  String id;
  String nombre;
  double largo;
  double ancho;
  int edadDias;
  double densidadPollos;
  int ventiladores;
  int nebulizadores;
  int sensores;
  double velocidadAire;
  double temperaturaInterna;
  double humedadInterna;

  Galpon({
    required this.id,
    required this.nombre,
    required this.largo,
    required this.ancho,
    required this.ventiladores,
    required this.nebulizadores,
    required this.sensores,
    required this.edadDias,
    required this.densidadPollos,
    this.velocidadAire = 0.0,
    this.temperaturaInterna = 0.0,
    this.humedadInterna = 0.0,
  });

factory Galpon.fromJson(Map<String, dynamic> json) {

  return Galpon(
    id: json['id'] as String? ?? '',
    nombre: json['nombre'] as String? ?? '',
    largo: (json['largo'] as num?)?.toDouble() ?? 0.0,
    ancho: (json['ancho'] as num?)?.toDouble() ?? 0.0,
    edadDias: (json['edadDias'] as num?)?.toInt() ?? 0,
    densidadPollos: (json['densidadPollos'] as num?)?.toDouble() ?? 0.0,
    ventiladores: json['ventiladores'] as int? ?? 0,
    nebulizadores: json['nebulizadores'] as int? ?? 0,
    sensores: json['sensores'] as int? ?? 0,
    velocidadAire: (json['velocidadAire'] as num?)?.toDouble() ?? 0.0,
    temperaturaInterna: (json['temperaturaInterna'] as num?)?.toDouble() ?? 0.0,
    humedadInterna: (json['humedadInterna'] as num?)?.toDouble() ?? 0.0,
  );
}


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'largo': largo,
      'ancho': ancho,
      'edadDias': edadDias,
      'densidadPollos': densidadPollos,
      'ventiladores': ventiladores,
      'nebulizadores': nebulizadores,
      'sensores': sensores,
      'velocidadAire': velocidadAire,
      'temperaturaInterna': temperaturaInterna,
      'humedadInterna': humedadInterna,
    };
  }

  Galpon copyWith({
    String? id,
    String? nombre,
    double? largo,
    double? ancho,
    double? densidadPollos,
    int? edadDias,
    int? ventiladores,
    int? sensores,
    int? nebulizadores,
    double? velocidadAire,
    double? temperaturaInterna,
    double? humedadInterna,
  }) {
    return Galpon(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      largo: largo ?? this.largo,
      ancho: ancho ?? this.ancho,
      edadDias: edadDias ?? this.edadDias,
      densidadPollos: densidadPollos ?? this.densidadPollos,
      ventiladores: ventiladores ?? this.ventiladores,
      sensores: sensores ?? this.sensores,
      nebulizadores: nebulizadores ?? this.nebulizadores,
      velocidadAire: velocidadAire ?? this.velocidadAire,
      temperaturaInterna: temperaturaInterna ?? this.temperaturaInterna,
      humedadInterna: humedadInterna ?? this.humedadInterna,
    );
  }

  Map<String, dynamic> toPrediccionJson() {
  return {
    "id_galpon": id,
    "edad_dias": edadDias,
    "densidad_pollos": densidadPollos,
    "velocidad_aire": velocidadAire,
    "temperatura_interna": temperaturaInterna,
    "humedad_interna": humedadInterna,
  };
}

}
