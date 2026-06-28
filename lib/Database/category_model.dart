class Category {
  final int? id;
  final String nombre;
  final String tipo;
  final String color;
  final bool esPredefinida;

  Category({
    this.id,
    required this.nombre,
    required this.tipo,
    required this.color,
    this.esPredefinida = false,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        nombre: json["nombre"],
        tipo: json["tipo"],
        color: json["color"],
        esPredefinida: json["es_predefinida"] == 1,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "tipo": tipo,
        "color": color,
        "es_predefinida": esPredefinida ? 1 : 0,
      };

  static List<Category> predefinedCategories = [
    // Ingresos
    Category(nombre: 'Salario', tipo: 'Ingreso', color: '#4CAF50', esPredefinida: true),
    Category(nombre: 'Freelance', tipo: 'Ingreso', color: '#66BB6A', esPredefinida: true),
    Category(nombre: 'Inversiones', tipo: 'Ingreso', color: '#81C784', esPredefinida: true),
    Category(nombre: 'Otros ingresos', tipo: 'Ingreso', color: '#A5D6A7', esPredefinida: true),
    // Gastos
    Category(nombre: 'Alimentación', tipo: 'Gasto', color: '#F44336', esPredefinida: true),
    Category(nombre: 'Transporte', tipo: 'Gasto', color: '#EF5350', esPredefinida: true),
    Category(nombre: 'Vivienda', tipo: 'Gasto', color: '#E53935', esPredefinida: true),
    Category(nombre: 'Entretenimiento', tipo: 'Gasto', color: '#D32F2F', esPredefinida: true),
    Category(nombre: 'Salud', tipo: 'Gasto', color: '#C62828', esPredefinida: true),
    Category(nombre: 'Educación', tipo: 'Gasto', color: '#B71C1C', esPredefinida: true),
    Category(nombre: 'Ropa', tipo: 'Gasto', color: '#FF5722', esPredefinida: true),
    Category(nombre: 'Servicios', tipo: 'Gasto', color: '#FF7043', esPredefinida: true),
    Category(nombre: 'Suscripciones', tipo: 'Gasto', color: '#FF8A65', esPredefinida: true),
    Category(nombre: 'Otros gastos', tipo: 'Gasto', color: '#FFAB91', esPredefinida: true),
    // Ahorros
    Category(nombre: 'Fondo de emergencia', tipo: 'Ahorro', color: '#2196F3', esPredefinida: true),
    Category(nombre: 'Metas de ahorro', tipo: 'Ahorro', color: '#42A5F5', esPredefinida: true),
    // Default
    Category(nombre: 'Sin categoría', tipo: 'General', color: '#9E9E9E', esPredefinida: true),
    Category(nombre: 'General', tipo: 'General', color: '#757575', esPredefinida: true),
  ];
}
