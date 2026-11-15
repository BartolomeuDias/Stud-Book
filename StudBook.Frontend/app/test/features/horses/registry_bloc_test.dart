import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:studbook_app/core/error/failure.dart';
import 'package:studbook_app/core/error/result.dart';
import 'package:studbook_app/core/usecase/usecase.dart';
import 'package:studbook_app/core/utils/load_status.dart';
import 'package:studbook_app/features/horses/domain/entities/horse.dart';
import 'package:studbook_app/features/horses/domain/usecases/horse_usecases.dart';
import 'package:studbook_app/features/horses/presentation/registry/bloc/registry_bloc.dart';

class _MockGetRegistry extends Mock implements GetRegistryUseCase {}

HorseSummary _horse(int id, String name, HorseCategory category, {String? owner}) => HorseSummary(
  id: id,
  name: name,
  category: category,
  sex: HorseSex.mare,
  breed: 'Quarter Horse',
  color: 'Bay',
  ownerName: owner,
  registrationNumber: 'QH-$id',
);

void main() {
  setUpAll(() => registerFallbackValue(const NoParams()));

  late _MockGetRegistry getRegistry;

  final horses = [
    _horse(3, 'Wichita Sally', HorseCategory.clientHorse, owner: 'Maple Creek'),
    _horse(1, 'CJ Red Mesa', HorseCategory.ownStallion),
    _horse(2, 'Bandera Starlet', HorseCategory.clientHorse, owner: 'J. Alvarez'),
  ];

  setUp(() => getRegistry = _MockGetRegistry());

  blocTest<RegistryBloc, RegistryState>(
    'loads and sorts horses by category, then name',
    setUp: () => when(() => getRegistry(any())).thenAnswer((_) async => Success(horses)),
    build: () => RegistryBloc(getRegistry),
    act: (bloc) => bloc.add(const RegistryRequested()),
    verify: (bloc) {
      expect(bloc.state.status, LoadStatus.success);
      expect(bloc.state.horses.map((horse) => horse.id), [1, 2, 3]);
      expect(bloc.state.countOf(HorseCategory.clientHorse), 2);
      expect(bloc.state.countOf(null), 3);
    },
  );

  blocTest<RegistryBloc, RegistryState>(
    'filters by category and search query',
    setUp: () => when(() => getRegistry(any())).thenAnswer((_) async => Success(horses)),
    build: () => RegistryBloc(getRegistry),
    act: (bloc) => bloc
      ..add(const RegistryRequested())
      ..add(const RegistryCategorySelected(HorseCategory.clientHorse))
      ..add(const RegistrySearchChanged('alvarez')),
    verify: (bloc) => expect(bloc.state.visible.single.name, 'Bandera Starlet'),
  );

  blocTest<RegistryBloc, RegistryState>(
    'exposes the failure when loading fails',
    setUp: () =>
        when(() => getRegistry(any())).thenAnswer((_) async => const Failed(NetworkFailure())),
    build: () => RegistryBloc(getRegistry),
    act: (bloc) => bloc.add(const RegistryRequested()),
    verify: (bloc) {
      expect(bloc.state.status, LoadStatus.failure);
      expect(bloc.state.failure, isA<NetworkFailure>());
    },
  );
}
