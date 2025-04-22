part of 'characters_bloc.dart';

abstract class CharactersEvent extends Equatable {
  const CharactersEvent();

  @override
  List<Object?> get props => [];
}

class LoadCharacters extends CharactersEvent {
  final bool loadMore;

  const LoadCharacters({this.loadMore = false});

  @override
  List<Object?> get props => [loadMore];
}

class SearchCharacters extends CharactersEvent {
  final String query;
  final bool loadMore;

  const SearchCharacters({required this.query, this.loadMore = false});

  @override
  List<Object?> get props => [query, loadMore];
}

class ToggleFavorite extends CharactersEvent {
  final Character character;

  const ToggleFavorite(this.character);

  @override
  List<Object?> get props => [character];
}

class LoadFavorites extends CharactersEvent {}

class ResetSearch extends CharactersEvent {}

class ToggleShowOnlyFavorites extends CharactersEvent {}

class ToggleViewType extends CharactersEvent {}
