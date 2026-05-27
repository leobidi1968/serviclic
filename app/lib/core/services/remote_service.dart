import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../models/categoria.dart';
// ignore: depend_on_referenced_packages
import 'package:typed_data/typed_data.dart' as td;
// dart:convert utf8 is used directly below

class RemoteService {
  static const _baseUrl = 'http://66.94.106.67:8003';

  Future<List<Categoria>> fetchCategorias() async {
    final response = await http
        .get(Uri.parse('$_baseUrl/categorias'))
        .timeout(const Duration(seconds: 10));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => Categoria.fromMap(e as Map<String, dynamic>)).toList();
    }
    throw Exception('Error ${response.statusCode} al obtener categorías');
  }

  Future<Map<String, dynamic>> crearEmpresa(Map<String, dynamic> data) async {
    final response = await http
        .post(
          Uri.parse('$_baseUrl/empresas/'),
          headers: {'Content-Type': 'application/json; charset=utf-8'},
          body: jsonEncode(data),
        )
        .timeout(const Duration(seconds: 15));
    if (response.statusCode == 201) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    }
    throw Exception('Error ${response.statusCode} al registrar empresa');
  }

  Future<Map<String, dynamic>> actualizarDocumentacion(
      int id, Map<String, dynamic> data) async {
    final response = await http
        .put(
          Uri.parse('$_baseUrl/empresas/$id/documentacion'),
          headers: {'Content-Type': 'application/json; charset=utf-8'},
          body: jsonEncode(data),
        )
        .timeout(const Duration(seconds: 15));
    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    }
    throw Exception('Error ${response.statusCode} al actualizar documentación');
  }
}

final categoriasProvider = FutureProvider<List<Categoria>>((ref) {
  return RemoteService().fetchCategorias();
});
