import 'package:equatable/equatable.dart';

class Character extends Equatable {
  final String name;
  final String height;
  final String mass;
  final String hairColor;
  final String skinColor;
  final String eyeColor;
  final String birthYear;
  final String gender;
  final String url;
  final bool isFavorite;

  const Character({
    required this.name,
    required this.height,
    required this.mass,
    required this.hairColor,
    required this.skinColor,
    required this.eyeColor,
    required this.birthYear,
    required this.gender,
    required this.url,
    this.isFavorite = false,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      name: json['name'] ?? '',
      height: json['height'] ?? '',
      mass: json['mass'] ?? '',
      hairColor: json['hair_color'] ?? '',
      skinColor: json['skin_color'] ?? '',
      eyeColor: json['eye_color'] ?? '',
      birthYear: json['birth_year'] ?? '',
      gender: json['gender'] ?? '',
      url: json['url'] ?? '',
    );
  }

  Character copyWith({
    String? name,
    String? height,
    String? mass,
    String? hairColor,
    String? skinColor,
    String? eyeColor,
    String? birthYear,
    String? gender,
    String? url,
    bool? isFavorite,
  }) {
    return Character(
      name: name ?? this.name,
      height: height ?? this.height,
      mass: mass ?? this.mass,
      hairColor: hairColor ?? this.hairColor,
      skinColor: skinColor ?? this.skinColor,
      eyeColor: eyeColor ?? this.eyeColor,
      birthYear: birthYear ?? this.birthYear,
      gender: gender ?? this.gender,
      url: url ?? this.url,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  List<Object?> get props => [
        name,
        height,
        mass,
        hairColor,
        skinColor,
        eyeColor,
        birthYear,
        gender,
        url,
        isFavorite,
      ];
}
