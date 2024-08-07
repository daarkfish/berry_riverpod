import 'package:dio/dio.dart';
import '../models/berry_model.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://pokeapi.co/api/v2/'));

  Future<List<Berry>> getBerries() async {
    try {
      final response = await _dio.get('berry');
      final results = response.data['results'] as List;
      final berries = await Future.wait(
        results.map((berry) => getBerryDetails(berry['name'])),
      );
      return berries;
    } catch (e) {
      throw Exception('Failed to load berries');
    }
  }

  Future<Berry> getBerryDetails(String name) async {
    try {
      final response = await _dio.get('berry/$name');
      return Berry.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load berry details');
    }
  }

  Future<List<Berry>> searchBerries(String query) async {
    try {
      final response = await _dio.get('berry?limit=64');
      final results = response.data['results'] as List;
      final allBerries = await Future.wait(
        results.map((berry) => getBerryDetails(berry['name'])),
      );
      return allBerries
          .where(
              (berry) => berry.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } catch (e) {
      throw Exception('Failed to search berries');
    }
  }
}
