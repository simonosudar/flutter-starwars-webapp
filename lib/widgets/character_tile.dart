import 'package:flutter/material.dart';
import 'package:starwars_web_app/models/character.dart';
import 'package:starwars_web_app/widgets/character_info_row.dart';

class CharacterTile extends StatelessWidget {
  final Character character;
  final Function(Character) onFavoriteToggle;

  const CharacterTile({
    super.key,
    required this.character,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    final double fontSize = isSmallScreen ? 12.0 : 14.0;

    return Card(
      margin:
          EdgeInsets.symmetric(horizontal: isSmallScreen ? 8 : 16, vertical: 8),
      child: ListTile(
        contentPadding: EdgeInsets.all(isSmallScreen ? 12 : 16),
        title: Text(
          character.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: isSmallScreen ? 16 : 18,
            color: Colors.yellow[800],
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            CharacterInfoRow(
                label: 'Género', value: character.gender, fontSize: fontSize),
            CharacterInfoRow(
                label: 'Altura',
                value: '${character.height} cm',
                fontSize: fontSize),
            CharacterInfoRow(
                label: 'Peso',
                value: '${character.mass} kg',
                fontSize: fontSize),
            CharacterInfoRow(
                label: 'Color de pelo',
                value: character.hairColor,
                fontSize: fontSize),
            CharacterInfoRow(
                label: 'Color de piel',
                value: character.skinColor,
                fontSize: fontSize),
            CharacterInfoRow(
                label: 'Color de ojos',
                value: character.eyeColor,
                fontSize: fontSize),
            CharacterInfoRow(
                label: 'Año de nacimiento',
                value: character.birthYear,
                fontSize: fontSize),
          ],
        ),
        trailing: IconButton(
          icon: Icon(
            character.isFavorite ? Icons.star : Icons.star_border,
            color: character.isFavorite ? Colors.yellow : null,
            size: isSmallScreen ? 24 : 30,
          ),
          onPressed: () => onFavoriteToggle(character),
        ),
      ),
    );
  }
}
