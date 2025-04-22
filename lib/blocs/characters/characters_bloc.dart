import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:starwars_web_app/models/character.dart';
import 'package:starwars_web_app/repositories/character_repository.dart';

part 'characters_event.dart';
part 'characters_state.dart';

class CharactersBloc extends Bloc<CharactersEvent, CharactersState> {
  final CharacterRepository _characterRepository;

  CharactersBloc(this._characterRepository) : super(const CharactersState()) {
    on<LoadCharacters>(_onLoadCharacters);
    on<SearchCharacters>(_onSearchCharacters);
    on<ToggleFavorite>(_onToggleFavorite);
    on<LoadFavorites>(_onLoadFavorites);
    on<ResetSearch>(_onResetSearch);
    on<ToggleShowOnlyFavorites>(_onToggleShowOnlyFavorites);
    on<ToggleViewType>(_onToggleViewType);
  }

  Future<void> _onLoadCharacters(
    LoadCharacters event,
    Emitter<CharactersState> emit,
  ) async {
    if (state.hasReachedMax && event.loadMore) return;

    try {
      if (state.status == CharactersStatus.initial || !event.loadMore) {
        emit(state.copyWith(
          status: CharactersStatus.loading,
          currentPage: 1,
        ));

        final response = await _characterRepository.getCharacters();
        return emit(state.copyWith(
          status: CharactersStatus.success,
          characters: response.results,
          hasReachedMax: response.next == null,
          currentPage: 1,
        ));
      }

      final nextPage = state.currentPage + 1;
      emit(state.copyWith(status: CharactersStatus.loading));

      final response = await _characterRepository.getCharacters(page: nextPage);

      emit(state.copyWith(
        status: CharactersStatus.success,
        characters: [...state.characters, ...response.results],
        hasReachedMax: response.next == null,
        currentPage: nextPage,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: CharactersStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onSearchCharacters(
    SearchCharacters event,
    Emitter<CharactersState> emit,
  ) async {
    if (event.query.isEmpty) {
      return add(const LoadCharacters());
    }

    if (state.hasReachedMax && event.loadMore) return;

    try {
      if (!event.loadMore) {
        emit(state.copyWith(
          status: CharactersStatus.loading,
          searchQuery: event.query,
          currentPage: 1,
        ));

        final response = await _characterRepository.searchCharacters(
          query: event.query,
        );

        return emit(state.copyWith(
          status: CharactersStatus.success,
          characters: response.results,
          hasReachedMax: response.next == null,
          currentPage: 1,
        ));
      }

      final nextPage = state.currentPage + 1;
      emit(state.copyWith(status: CharactersStatus.loading));

      final response = await _characterRepository.searchCharacters(
        query: event.query,
        page: nextPage,
      );

      emit(state.copyWith(
        status: CharactersStatus.success,
        characters: [...state.characters, ...response.results],
        hasReachedMax: response.next == null,
        currentPage: nextPage,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: CharactersStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onToggleFavorite(
    ToggleFavorite event,
    Emitter<CharactersState> emit,
  ) async {
    try {
      await _characterRepository.toggleFavorite(event.character);

      final updatedCharacters = state.characters.map((character) {
        if (character.url == event.character.url) {
          return character.copyWith(isFavorite: !character.isFavorite);
        }
        return character;
      }).toList();

      List<Character> updatedFavorites;

      if (event.character.isFavorite) {
        updatedFavorites =
            state.favorites.where((c) => c.url != event.character.url).toList();
      } else {
        updatedFavorites = [
          ...state.favorites,
          event.character.copyWith(isFavorite: true)
        ];
      }

      emit(state.copyWith(
        characters: updatedCharacters,
        favorites: updatedFavorites,
      ));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Error al actualizar favorito: ${e.toString()}',
      ));
    }
  }

  Future<void> _onLoadFavorites(
    LoadFavorites event,
    Emitter<CharactersState> emit,
  ) async {
    try {
      if (state.status == CharactersStatus.initial) {
        emit(state.copyWith(status: CharactersStatus.loading));
      }

      final favorites = await _characterRepository.getFavoriteCharacters();

      emit(state.copyWith(
        status: CharactersStatus.success,
        favorites: favorites,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: CharactersStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onResetSearch(
    ResetSearch event,
    Emitter<CharactersState> emit,
  ) {
    emit(state.copyWith(searchQuery: ''));
    add(const LoadCharacters());
  }

  void _onToggleShowOnlyFavorites(
    ToggleShowOnlyFavorites event,
    Emitter<CharactersState> emit,
  ) {
    emit(state.copyWith(
      showOnlyFavorites: !state.showOnlyFavorites,
      status:
          state.status == CharactersStatus.initial && state.characters.isEmpty
              ? CharactersStatus.loading
              : state.status,
    ));
  }

  void _onToggleViewType(
    ToggleViewType event,
    Emitter<CharactersState> emit,
  ) {
    final newViewType =
        state.viewType == ViewType.list ? ViewType.grid : ViewType.list;
    emit(state.copyWith(viewType: newViewType));
  }
}
