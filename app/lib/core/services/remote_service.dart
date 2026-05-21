import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../models/categoria.dart';

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
}

final categoriasProvider = FutureProvider<List<Categoria>>((ref) {
  return RemoteService().fetchCategorias();
});
