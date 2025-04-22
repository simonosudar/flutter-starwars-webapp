import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:starwars_web_app/models/character.dart';
import 'package:starwars_web_app/models/characters_response.dart';
import 'package:starwars_web_app/repositories/character_repository.dart';
import 'package:starwars_web_app/services/swapi_service.dart';

class CharacterRepositoryImpl implements CharacterRepository {
  final SwapiService _swapiService;
  final SharedPreferences _sharedPreferences;
  static const String _favoritesKey = 'favorites';

  CharacterRepositoryImpl(this._swapiService, this._sharedPreferences);

  @override
  Future<CharactersResponse> getCharacters({int page = 1}) async {
    final response = await _swapiService.getCharacters(page: page);
    final List<Character> updatedResults = [];

    for (var character in response.results) {
      final isCharacterFavorite = await isFavorite(character.url);
      updatedResults.add(character.copyWith(isFavorite: isCharacterFavorite));
    }

    return CharactersResponse(
      count: response.count,
      next: response.next,
      previous: response.previous,
      results: updatedResults,
    );
  }

  @override
  Future<CharactersResponse> searchCharacters(
      {required String query, int page = 1}) async {
    final response =
        await _swapiService.searchCharacters(query: query, page: page);
    final List<Character> updatedResults = [];

    for (var character in response.results) {
      final isCharacterFavorite = await isFavorite(character.url);
      updatedResults.add(character.copyWith(isFavorite: isCharacterFavorite));
    }

    return CharactersResponse(
      count: response.count,
      next: response.next,
      previous: response.previous,
      results: updatedResults,
    );
  }

  @override
  Future<List<Character>> getFavoriteCharacters() async {
    final favoritesJson = _sharedPreferences.getStringList(_favoritesKey) ?? [];
    return favoritesJson.map((json) {
      final Map<String, dynamic> data = jsonDecode(json);
      return Character.fromJson(data).copyWith(isFavorite: true);
    }).toList();
  }

  @override
  Future<void> toggleFavorite(Character character) async {
    final List<String> favoritesJson =
        _sharedPreferences.getStringList(_favoritesKey) ?? [];

    final List<Map<String, dynamic>> favorites = favoritesJson
        .map((json) => jsonDecode(json) as Map<String, dynamic>)
        .toList();

    final index = favorites.indexWhere((fav) => fav['url'] == character.url);

    if (index >= 0) {
      favorites.removeAt(index);
    } else {
      final Map<String, dynamic> characterMap = {
        'name': character.name,
        'height': character.height,
        'mass': character.mass,
        'hair_color': character.hairColor,
        'skin_color': character.skinColor,
        'eye_color': character.eyeColor,
        'birth_year': character.birthYear,
        'gender': character.gender,
        'url': character.url,
      };
      favorites.add(characterMap);
    }

    final updatedFavoritesJson =
        favorites.map((fav) => jsonEncode(fav)).toList();
    await _sharedPreferences.setStringList(_favoritesKey, updatedFavoritesJson);
  }

  @override
  Future<bool> isFavorite(String url) async {
    final favoritesJson = _sharedPreferences.getStringList(_favoritesKey) ?? [];
    final favorites = favoritesJson
        .map((json) => jsonDecode(json) as Map<String, dynamic>)
        .toList();
    return favorites.any((fav) => fav['url'] == url);
  }
}
