// characters_bloc_test.dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:starwars_web_app/blocs/characters/characters_bloc.dart';
import 'package:starwars_web_app/models/character.dart';
import 'package:starwars_web_app/models/characters_response.dart';
import 'package:starwars_web_app/repositories/character_repository.dart';

class MockCharacterRepository extends Mock implements CharacterRepository {}

class FakeCharacter extends Fake implements Character {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeCharacter());
  });

  group('CharactersBloc', () {
    late MockCharacterRepository mockRepo;
    late CharactersBloc bloc;

    setUp(() {
      mockRepo = MockCharacterRepository();
      bloc = CharactersBloc(mockRepo);
    });

    const character = Character(
      name: 'Luke Skywalker',
      url: '1',
      height: '172',
      mass: '77',
      hairColor: 'blond',
      skinColor: 'fair',
      eyeColor: 'blue',
      birthYear: '19BBY',
      gender: 'male',
    );

    test('initial state is CharactersState()', () {
      expect(bloc.state, const CharactersState());
    });

    blocTest<CharactersBloc, CharactersState>(
      'emits [loading, success] on successful LoadCharacters',
      build: () {
        when(() => mockRepo.getCharacters(page: any(named: 'page')))
            .thenAnswer((_) async => CharactersResponse(
                  count: 1,
                  next: null,
                  previous: null,
                  results: [character],
                ));
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadCharacters()),
      expect: () => [
        const CharactersState(status: CharactersStatus.loading, currentPage: 1),
        const CharactersState(
          status: CharactersStatus.success,
          characters: [character],
          hasReachedMax: true,
          currentPage: 1,
        ),
      ],
      verify: (_) => verify(() => mockRepo.getCharacters()).called(1),
    );

    blocTest<CharactersBloc, CharactersState>(
      'emits [loading, failure] on failed LoadCharacters',
      build: () {
        when(() => mockRepo.getCharacters(page: any(named: 'page')))
            .thenThrow(Exception('error'));
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadCharacters()),
      expect: () => [
        const CharactersState(status: CharactersStatus.loading, currentPage: 1),
        isA<CharactersState>()
            .having((s) => s.status, 'status', CharactersStatus.failure)
            .having(
                (s) => s.errorMessage, 'errorMessage', contains('Exception')),
      ],
    );

    blocTest<CharactersBloc, CharactersState>(
      'emits updated state with toggled favorite',
      build: () {
        when(() => mockRepo.toggleFavorite(any())).thenAnswer((_) async {});
        final preFav = character.copyWith(isFavorite: false);
        bloc.emit(bloc.state.copyWith(
          characters: [preFav],
          favorites: [],
          status: CharactersStatus.success,
        ));
        return bloc;
      },
      act: (bloc) => bloc.add(const ToggleFavorite(character)),
      expect: () => [
        isA<CharactersState>()
            .having((s) => s.characters.first.isFavorite, 'isFavorite', true)
            .having((s) => s.favorites.length, 'favorites.length', 1),
      ],
    );

    blocTest<CharactersBloc, CharactersState>(
      'emits [loading, success] on successful SearchCharacters',
      build: () {
        when(() => mockRepo.searchCharacters(query: any(named: 'query')))
            .thenAnswer((_) async => CharactersResponse(
                  count: 1,
                  next: null,
                  previous: null,
                  results: [character],
                ));
        return bloc;
      },
      act: (bloc) => bloc.add(const SearchCharacters(query: 'Luke')),
      expect: () => [
        const CharactersState(
            status: CharactersStatus.loading,
            searchQuery: 'Luke',
            currentPage: 1),
        const CharactersState(
          status: CharactersStatus.success,
          characters: [character],
          hasReachedMax: true,
          searchQuery: 'Luke',
          currentPage: 1,
        ),
      ],
      verify: (_) =>
          verify(() => mockRepo.searchCharacters(query: 'Luke')).called(1),
    );

    blocTest<CharactersBloc, CharactersState>(
      'toggles showOnlyFavorites flag',
      build: () => bloc,
      act: (bloc) => bloc.add(ToggleShowOnlyFavorites()),
      expect: () => [
        const CharactersState(
          showOnlyFavorites: true,
          status: CharactersStatus.loading,
        ),
      ],
    );
  });
}
