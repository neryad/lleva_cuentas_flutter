class GastoRecurrente {
  int? id;
  String descripcion;
  double monto;
  int? categoriaId;
  int diaPago;
  bool activo;

  GastoRecurrente({
    this.id,
    required this.descripcion,
    required this.monto,
    this.categoriaId,
    required this.diaPago,
    this.activo = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'descripcion': descripcion,
      'monto': monto,
      'categoria_id': categoriaId,
      'dia_pago': diaPago,
      'activo': activo ? 1 : 0,
    };
  }

  factory GastoRecurrente.fromJson(Map<String, dynamic> json) {
    return GastoRecurrente(
      id: json['id'] as int?,
      descripcion: json['descripcion'] as String,
      monto: (json['monto'] as num).toDouble(),
      categoriaId: json['categoria_id'] as int?,
      diaPago: json['dia_pago'] as int,
      activo: (json['activo'] as int?) == 1,
    );
  }
}