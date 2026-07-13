class MetaAhorro {
  int? id;
  String nombre;
  double montoObjetivo;
  double montoActual;
  String? fechaLimite;
  String? color;
  bool completada;

  MetaAhorro({
    this.id,
    required this.nombre,
    required this.montoObjetivo,
    this.montoActual = 0,
    this.fechaLimite,
    this.color,
    this.completada = false,
  });

  double get progreso =>
      montoObjetivo > 0 ? (montoActual / montoObjetivo).clamp(0.0, 1.0) : 0;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'monto_objetivo': montoObjetivo,
      'monto_actual': montoActual,
      'fecha_limite': fechaLimite,
      'color': color,
      'completada': completada ? 1 : 0,
    };
  }

  factory MetaAhorro.fromJson(Map<String, dynamic> json) {
    return MetaAhorro(
      id: json['id'] as int?,
      nombre: json['nombre'] as String,
      montoObjetivo: (json['monto_objetivo'] as num).toDouble(),
      montoActual: (json['monto_actual'] as num?)?.toDouble() ?? 0,
      fechaLimite: json['fecha_limite'] as String?,
      color: json['color'] as String?,
      completada: (json['completada'] as int?) == 1,
    );
  }
}