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
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      largo: (json['largo'] as num).toDouble(),
      ancho: (json['ancho'] as num).toDouble(),
      edadDias: (json['edadDias'] as num).toInt(),
      densidadPollos: (json['densidadPollos'] as num).toDouble(),
      ventiladores: json['ventiladores'] as int,
      nebulizadores: json['nebulizadores'] as int,
      sensores: json['sensores'] as int,
            velocidadAire: (json['velocidadAire'] as num).toDouble(),
      temperaturaInterna: (json['temperaturaInterna'] as num).toDouble(),
      humedadInterna: (json['humedadInterna'] as num).toDouble(),
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
}
