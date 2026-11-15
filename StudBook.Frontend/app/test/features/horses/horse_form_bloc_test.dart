import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:studbook_app/core/error/result.dart';
import 'package:studbook_app/core/usecase/usecase.dart';
import 'package:studbook_app/core/utils/load_status.dart';
import 'package:studbook_app/features/clients/domain/entities/client.dart';
import 'package:studbook_app/features/clients/domain/usecases/get_clients.dart';
import 'package:studbook_app/features/horses/domain/entities/horse.dart';
import 'package:studbook_app/features/horses/domain/usecases/horse_usecases.dart';
import 'package:studbook_app/features/horses/presentation/form/bloc/horse_form_bloc.dart';

class _MockGetHorse extends Mock implements GetHorseUseCase {}

class _MockGetRegistry extends Mock implements GetRegistryUseCase {}

class _MockGetClients extends Mock implements GetClientsUseCase {}

class _MockSaveHorse extends Mock implements SaveHorseUseCase {}

const _stallion = HorseSummary(
  id: 1,
  name: 'CJ Red Mesa',
  category: HorseCategory.ownStallion,
  sex: HorseSex.stallion,
  breed: 'Quarter Horse',
  color: 'Sorrel',
);

const _mare = HorseSummary(
  id: 2,
  name: 'Sierra Bluebonnet',
  category: HorseCategory.clientHorse,
  sex: HorseSex.mare,
  breed: 'Quarter Horse',
  color: 'Bay',
);

const _saved = HorseDetails(
  id: 9,
  name: 'New Foal',
  category: HorseCategory.clientHorse,
  sex: HorseSex.mare,
  breed: 'Quarter Horse',
  color: 'Bay',
  notes: '',
  isActive: true,
  pedigree: Pedigree(),
);

void main() {
  setUpAll(() {
    registerFallbackValue(const NoParams());
    registerFallbackValue(const SaveHorseParams(draft: HorseDraft()));
  });

  late _MockGetHorse getHorse;
  late _MockGetRegistry getRegistry;
  late _MockGetClients getClients;
  late _MockSaveHorse saveHorse;

  setUp(() {
    getHorse = _MockGetHorse();
    getRegistry = _MockGetRegistry();
    getClients = _MockGetClients();
    saveHorse = _MockSaveHorse();
    when(() => getRegistry(any())).thenAnswer((_) async => const Success([_stallion, _mare]));
    when(() => getClients(any())).thenAnswer(
      (_) async => const Success([Client(id: 1, name: 'Hill Country', type: ClientType.stable)]),
    );
  });

  HorseFormBloc build() => HorseFormBloc(
    getHorse: getHorse,
    getRegistry: getRegistry,
    getClients: getClients,
    saveHorse: saveHorse,
  );

  blocTest<HorseFormBloc, HorseFormState>(
    'splits registry horses into sire and dam options',
    build: build,
    act: (bloc) => bloc.add(const HorseFormStarted()),
    verify: (bloc) {
      expect(bloc.state.status, LoadStatus.success);
      expect(bloc.state.sires.single.id, _stallion.id);
      expect(bloc.state.dams.single.id, _mare.id);
      expect(bloc.state.clients, hasLength(1));
    },
  );

  blocTest<HorseFormBloc, HorseFormState>(
    'does not submit while required fields are empty',
    build: build,
    act: (bloc) => bloc
      ..add(const HorseFormStarted())
      ..add(const HorseFormSubmitted()),
    verify: (bloc) {
      expect(bloc.state.showErrors, isTrue);
      expect(bloc.state.hasError(HorseFormField.name), isTrue);
      expect(bloc.state.firstInvalid, HorseFormField.name);
      expect(bloc.state.validationAttempt, 1);
      verifyNever(() => saveHorse(any()));
    },
  );

  blocTest<HorseFormBloc, HorseFormState>(
    'saves a valid draft and exposes the new id',
    setUp: () => when(() => saveHorse(any())).thenAnswer((_) async => const Success(_saved)),
    build: build,
    act: (bloc) => bloc
      ..add(const HorseFormStarted())
      ..add(
        const HorseFormChanged(
          HorseDraft(name: 'New Foal', breed: 'Quarter Horse', color: 'Bay', ownerClientId: 1),
        ),
      )
      ..add(const HorseFormSubmitted()),
    verify: (bloc) {
      expect(bloc.state.submit, SubmitStatus.success);
      expect(bloc.state.savedHorseId, _saved.id);
    },
  );

  blocTest<HorseFormBloc, HorseFormState>(
    'requires an owner for client horses but not for own stallions',
    build: build,
    act: (bloc) => bloc
      ..add(const HorseFormStarted())
      ..add(const HorseFormChanged(HorseDraft(name: 'Foal', breed: 'Quarter Horse', color: 'Bay')))
      ..add(const HorseFormSubmitted())
      ..add(
        const HorseFormChanged(
          HorseDraft(
            name: 'Foal',
            breed: 'Quarter Horse',
            color: 'Bay',
            category: HorseCategory.ownStallion,
            sex: HorseSex.stallion,
          ),
        ),
      ),
    verify: (bloc) {
      expect(bloc.state.validationAttempt, 1);
      expect(bloc.state.invalidFields, isEmpty);
      verifyNever(() => saveHorse(any()));
    },
  );
}
