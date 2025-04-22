import 'package:dio/dio.dart';
import 'package:starwars_web_app/models/characters_response.dart';

class SwapiService {
  final Dio _dio;
  final String _baseUrl = 'https://swapi.py4e.com/api';

  SwapiService(this._dio);

  Future<CharactersResponse> getCharacters({int page = 1}) async {
    try {
      final response = await _dio.get('$_baseUrl/people/?page=$page');
      return CharactersResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('No se pudieron cargar los personajes: $e');
    }
  }

  Future<CharactersResponse> searchCharacters(
      {required String query, int page = 1}) async {
    try {
      final response =
          await _dio.get('$_baseUrl/people/?search=$query&page=$page');
      return CharactersResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('No se pudieron buscar personajes: $e');
    }
  }
}
