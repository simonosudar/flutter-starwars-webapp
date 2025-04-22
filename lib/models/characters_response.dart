import 'package:starwars_web_app/models/character.dart';

class CharactersResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<Character> results;

  CharactersResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory CharactersResponse.fromJson(Map<String, dynamic> json) {
    return CharactersResponse(
      count: json['count'] ?? 0,
      next: json['next'],
      previous: json['previous'],
      results: (json['results'] as List?)
              ?.map((e) => Character.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
