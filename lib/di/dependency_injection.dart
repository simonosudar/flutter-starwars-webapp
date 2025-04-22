import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starwars_web_app/blocs/characters/characters_bloc.dart';
import 'package:starwars_web_app/repositories/character_repository.dart';
import 'package:starwars_web_app/repositories/character_repository_impl.dart';
import 'package:starwars_web_app/services/swapi_service.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);
  getIt.registerSingleton<Dio>(Dio());

  getIt.registerSingleton<SwapiService>(SwapiService(getIt<Dio>()));

  getIt.registerSingleton<CharacterRepository>(
    CharacterRepositoryImpl(
      getIt<SwapiService>(),
      getIt<SharedPreferences>(),
    ),
  );
  getIt.registerFactory<CharactersBloc>(
    () => CharactersBloc(getIt<CharacterRepository>()),
  );
}
