part of 'characters_bloc.dart';

enum CharactersStatus { initial, loading, success, failure }

enum ViewType { list, grid }

class CharactersState extends Equatable {
  final CharactersStatus status;
  final List<Character> characters;
  final List<Character> favorites;
  final bool hasReachedMax;
  final String searchQuery;
  final bool showOnlyFavorites;
  final String? errorMessage;
  final int currentPage;
  final ViewType viewType;

  const CharactersState({
    this.status = CharactersStatus.initial,
    this.characters = const [],
    this.favorites = const [],
    this.hasReachedMax = false,
    this.searchQuery = '',
    this.showOnlyFavorites = false,
    this.errorMessage,
    this.currentPage = 1,
    this.viewType = ViewType.list,
  });

  CharactersState copyWith({
    CharactersStatus? status,
    List<Character>? characters,
    List<Character>? favorites,
    bool? hasReachedMax,
    String? searchQuery,
    bool? showOnlyFavorites,
    String? errorMessage,
    int? currentPage,
    ViewType? viewType,
  }) {
    return CharactersState(
      status: status ?? this.status,
      characters: characters ?? this.characters,
      favorites: favorites ?? this.favorites,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      searchQuery: searchQuery ?? this.searchQuery,
      showOnlyFavorites: showOnlyFavorites ?? this.showOnlyFavorites,
      errorMessage: errorMessage,
      currentPage: currentPage ?? this.currentPage,
      viewType: viewType ?? this.viewType,
    );
  }

  List<Character> get displayCharacters {
    if (showOnlyFavorites) {
      return favorites;
    }
    return characters;
  }

  @override
  List<Object?> get props => [
        status,
        characters,
        favorites,
        hasReachedMax,
        searchQuery,
        showOnlyFavorites,
        errorMessage,
        currentPage,
        viewType,
      ];
}
