class Galpon {
  String id;
  String nombre;
  double largo;
  double ancho;
  int ventiladores;
  int nebulizadores;
  int sensores;

  Galpon({
    required this.id,
    required this.nombre,
    required this.largo,
    required this.ancho,
    required this.ventiladores,
    required this.nebulizadores,
    required this.sensores,
  });

  factory Galpon.fromJson(Map<String, dynamic> json) {
    return Galpon(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      largo: (json['largo'] as num).toDouble(),
      ancho: (json['ancho'] as num).toDouble(),
      ventiladores: json['ventiladores'] as int,
      nebulizadores: json['nebulizadores'] as int,
      sensores: json['sensores'] as int,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'largo': largo,
      'ancho': ancho,
      'ventiladores': ventiladores,
      'nebulizadores': nebulizadores,
      'sensores': sensores,
    };
  }

  Galpon copyWith({
    String? id,
    String? nombre,
    double? largo,
    double? ancho,
    int? ventiladores,
    int? sensores,
    int? nebulizadores,
  }) {
    return Galpon(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      largo: largo ?? this.largo,
      ancho: ancho ?? this.ancho,
      ventiladores: ventiladores ?? this.ventiladores,
      sensores: sensores ?? this.sensores,
      nebulizadores: nebulizadores ?? this.nebulizadores,
    );
  }
}
