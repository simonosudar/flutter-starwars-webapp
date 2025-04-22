import 'package:starwars_web_app/models/character.dart';
import 'package:starwars_web_app/models/characters_response.dart';

abstract class CharacterRepository {
  /// Get characters with pagination
  Future<CharactersResponse> getCharacters({int page = 1});

  /// Search characters by name
  Future<CharactersResponse> searchCharacters(
      {required String query, int page = 1});

  /// Get favorite characters saved locally
  Future<List<Character>> getFavoriteCharacters();

  /// Save a character in favorites
  Future<void> toggleFavorite(Character character);

  /// Check if a character is in favorites
  Future<bool> isFavorite(String url);
}
