import 'package:flutter/material.dart';

class Categoria {
  final int id;
  final String nombre;
  final String icono;

  const Categoria({
    required this.id,
    required this.nombre,
    required this.icono,
  });

  factory Categoria.fromMap(Map<String, dynamic> map) => Categoria(
        id: map['id'] as int,
        nombre: map['nombre'] as String,
        icono: map['icono'] as String,
      );

  IconData get iconData {
    const iconos = {
      'hogar': Icons.home_outlined,
      'electricidad': Icons.bolt_outlined,
      'plomeria': Icons.plumbing_outlined,
      'tecnologia': Icons.computer_outlined,
      'limpieza': Icons.cleaning_services_outlined,
      'pintura': Icons.format_paint_outlined,
      'cerrajeria': Icons.lock_outlined,
      'jardineria': Icons.yard_outlined,
      'mudanzas': Icons.local_shipping_outlined,
      'refrigeracion': Icons.ac_unit_outlined,
      'albanileria': Icons.construction_outlined,
      'gas': Icons.local_fire_department_outlined,
      'carpinteria': Icons.carpenter_outlined,
    };
    return iconos[icono.toLowerCase()] ?? Icons.miscellaneous_services_outlined;
  }
}
