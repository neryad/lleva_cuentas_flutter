class Presupuesto {
  int? id;
  int categoriaId;
  double montoLimite;
  int mes;
  int anio;

  Presupuesto({
    this.id,
    required this.categoriaId,
    required this.montoLimite,
    required this.mes,
    required this.anio,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'categoria_id': categoriaId,
      'monto_limite': montoLimite,
      'mes': mes,
      'anio': anio,
    };
  }

  factory Presupuesto.fromJson(Map<String, dynamic> json) {
    return Presupuesto(
      id: json['id'] as int?,
      categoriaId: json['categoria_id'] as int,
      montoLimite: (json['monto_limite'] as num).toDouble(),
      mes: json['mes'] as int,
      anio: json['anio'] as int,
    );
  }
}