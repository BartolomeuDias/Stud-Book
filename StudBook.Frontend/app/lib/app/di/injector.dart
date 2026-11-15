import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/network/api_client.dart';
import '../../features/auth/data/datasources/auth_data_sources.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/auth_usecases.dart';
import '../../features/auth/presentation/bloc/session_bloc.dart';
import '../../features/clients/data/datasources/client_remote_data_source.dart';
import '../../features/clients/data/repositories/client_repository_impl.dart';
import '../../features/clients/domain/repositories/client_repository.dart';
import '../../features/clients/domain/usecases/get_clients.dart';
import '../../features/compatibility_rules/data/datasources/compatibility_rule_remote_data_source.dart';
import '../../features/compatibility_rules/data/repositories/compatibility_rule_repository_impl.dart';
import '../../features/compatibility_rules/domain/repositories/compatibility_rule_repository.dart';
import '../../features/compatibility_rules/domain/usecases/rule_usecases.dart';
import '../../features/compatibility_rules/presentation/bloc/rules_bloc.dart';
import '../../features/horses/data/datasources/horse_remote_data_source.dart';
import '../../features/horses/data/repositories/horse_repository_impl.dart';
import '../../features/horses/domain/entities/horse.dart';
import '../../features/horses/domain/repositories/horse_repository.dart';
import '../../features/horses/domain/usecases/horse_usecases.dart';
import '../../features/horses/presentation/details/bloc/horse_details_bloc.dart';
import '../../features/horses/presentation/form/bloc/horse_form_bloc.dart';
import '../../features/horses/presentation/registry/bloc/registry_bloc.dart';

final sl = GetIt.instance;

Future<void> configureDependencies() async {
  final preferences = await SharedPreferences.getInstance();

  sl
    ..registerSingleton<SharedPreferences>(preferences)
    ..registerLazySingleton<ApiClient>(ApiClient.create)
    ..registerLazySingleton(() => AuthRemoteDataSource(sl()))
    ..registerLazySingleton(() => AuthLocalDataSource(sl()))
    ..registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl(), sl()))
    ..registerLazySingleton(() => LoginUseCase(sl()))
    ..registerLazySingleton(() => RestoreSessionUseCase(sl()))
    ..registerLazySingleton(() => LogoutUseCase(sl()))
    ..registerLazySingleton(() => ClientRemoteDataSource(sl()))
    ..registerLazySingleton<ClientRepository>(() => ClientRepositoryImpl(sl()))
    ..registerLazySingleton(() => GetClientsUseCase(sl()))
    ..registerLazySingleton(() => HorseRemoteDataSource(sl()))
    ..registerLazySingleton<HorseRepository>(() => HorseRepositoryImpl(sl()))
    ..registerLazySingleton(() => GetRegistryUseCase(sl()))
    ..registerLazySingleton(() => GetHorseUseCase(sl()))
    ..registerLazySingleton(() => SaveHorseUseCase(sl()))
    ..registerLazySingleton(() => RemoveHorseUseCase(sl()))
    ..registerFactoryParam<RegistryBloc, HorseCategory?, void>(
      (category, _) => RegistryBloc(sl(), initialCategory: category),
    )
    ..registerFactoryParam<HorseDetailsBloc, int, void>(
      (id, _) => HorseDetailsBloc(horseId: id, getHorse: sl(), removeHorse: sl()),
    )
    ..registerFactoryParam<HorseFormBloc, int?, void>(
      (id, _) => HorseFormBloc(
        horseId: id,
        getHorse: sl(),
        getRegistry: sl(),
        getClients: sl(),
        saveHorse: sl(),
      ),
    )
    ..registerLazySingleton(() => CompatibilityRuleRemoteDataSource(sl()))
    ..registerLazySingleton<CompatibilityRuleRepository>(
      () => CompatibilityRuleRepositoryImpl(sl()),
    )
    ..registerLazySingleton(() => GetRulesUseCase(sl()))
    ..registerLazySingleton(() => UpdateRuleUseCase(sl()))
    ..registerFactory(() => RulesBloc(getRules: sl(), updateRule: sl()));

  final restored = await sl<RestoreSessionUseCase>()();
  sl.registerLazySingleton(() => SessionBloc(login: sl(), logout: sl(), initialSession: restored));
}
