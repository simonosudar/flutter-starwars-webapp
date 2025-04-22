import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:starwars_web_app/blocs/characters/characters_bloc.dart';
import 'package:starwars_web_app/widgets/character_card.dart';
import 'package:starwars_web_app/widgets/character_tile.dart';
import 'package:starwars_web_app/widgets/search_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scrollController = ScrollController();
  late CharactersBloc _charactersBloc;

  @override
  void initState() {
    super.initState();
    _charactersBloc = context.read<CharactersBloc>();
    _scrollController.addListener(_onScroll);

    _charactersBloc.add(const LoadCharacters());
    _charactersBloc.add(LoadFavorites());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isNearBottom && !_isLoading) {
      _loadMore();
    }
  }

  bool get _isNearBottom {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  bool get _isLoading =>
      _charactersBloc.state.status == CharactersStatus.loading;

  void _loadMore() {
    final state = _charactersBloc.state;

    if (state.showOnlyFavorites) return;

    if (state.searchQuery.isEmpty) {
      _charactersBloc.add(const LoadCharacters(loadMore: true));
    } else {
      _charactersBloc.add(
        SearchCharacters(query: state.searchQuery, loadMore: true),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Star Wars Explorer',
          style: TextStyle(
            color: Colors.yellow[600],
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          BlocBuilder<CharactersBloc, CharactersState>(
            builder: (context, state) {
              return Row(
                children: [
                  IconButton(
                    icon: Icon(
                      state.viewType == ViewType.list
                          ? Icons.grid_view
                          : Icons.view_list,
                    ),
                    onPressed: () => _charactersBloc.add(ToggleViewType()),
                    tooltip: state.viewType == ViewType.list
                        ? 'Ver como grilla'
                        : 'Ver como lista',
                  ),
                  if (!isSmallScreen) const SizedBox(width: 8),
                  if (!isSmallScreen) const Text('Mostrar sólo favoritos'),
                  IconButton(
                    icon: Icon(
                      state.showOnlyFavorites ? Icons.star : Icons.star_border,
                      color: state.showOnlyFavorites ? Colors.yellow : null,
                    ),
                    onPressed: () =>
                        _charactersBloc.add(ToggleShowOnlyFavorites()),
                    tooltip: 'Mostrar favoritos',
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Center(
            child: Text(
              'Explora personajes de una galaxia muy, muy lejana',
              style: TextStyle(
                color: Colors.yellow[100],
                fontSize: 16,
              ),
            ),
          ),
          CustomSearchBar(
            onSearch: (query) {
              if (query.isEmpty) {
                _charactersBloc.add(ResetSearch());
              } else {
                _charactersBloc.add(SearchCharacters(query: query));
              }
            },
          ),
          Expanded(
            child: BlocBuilder<CharactersBloc, CharactersState>(
              builder: (context, state) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _buildBody(state, isSmallScreen, screenWidth),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(
      CharactersState state, bool isSmallScreen, double screenWidth) {
    switch (state.status) {
      case CharactersStatus.initial:
        return const Center(child: CircularProgressIndicator());

      case CharactersStatus.loading:
        return _buildCharactersList(state, isSmallScreen, screenWidth);

      case CharactersStatus.success:
        if (state.displayCharacters.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                state.showOnlyFavorites
                    ? 'No tienes personajes favoritos'
                    : 'No se encontraron personajes ${state.searchQuery.isNotEmpty ? 'para "${state.searchQuery}"' : ''}',
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
        return _buildCharactersList(state, isSmallScreen, screenWidth);

      case CharactersStatus.failure:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Error: ${state.errorMessage ?? "Desconocido"}',
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => _charactersBloc.add(const LoadCharacters()),
                  child: const Text('Reintentar'),
                )
              ],
            ),
          ),
        );
    }
  }

  Widget _buildCharactersList(
      CharactersState state, bool isSmallScreen, double screenWidth) {
    return state.viewType == ViewType.list
        ? _buildListView(state)
        : _buildGridView(state, screenWidth);
  }

  bool _shouldShowLoadingIndicator(CharactersState state) =>
      !state.hasReachedMax && state.displayCharacters.length >= 9;

  Widget _buildListView(CharactersState state) {
    final showLoadingIndicator = _shouldShowLoadingIndicator(state);

    return ListView.builder(
      controller: _scrollController,
      itemCount:
          state.displayCharacters.length + (showLoadingIndicator ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= state.displayCharacters.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        final character = state.displayCharacters[index];
        return CharacterTile(
          character: character,
          onFavoriteToggle: (character) {
            _charactersBloc.add(ToggleFavorite(character));
          },
        );
      },
    );
  }

  Widget _buildGridView(CharactersState state, double screenWidth) {
    final crossAxisCount = screenWidth > 900
        ? 4
        : screenWidth > 600
            ? 3
            : 2;

    final showLoadingIndicator = _shouldShowLoadingIndicator(state);

    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(8.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 0.75,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount:
          state.displayCharacters.length + (showLoadingIndicator ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= state.displayCharacters.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        final character = state.displayCharacters[index];
        return CharacterCard(
          character: character,
          onFavoriteToggle: (character) {
            _charactersBloc.add(ToggleFavorite(character));
          },
          isSmallScreen: screenWidth < 600,
        );
      },
    );
  }
}
