import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:studbook_app/core/error/failure.dart';
import 'package:studbook_app/core/error/result.dart';
import 'package:studbook_app/features/auth/domain/entities/user.dart';
import 'package:studbook_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:studbook_app/features/auth/domain/usecases/auth_usecases.dart';
import 'package:studbook_app/features/auth/presentation/bloc/session_bloc.dart';

class _MockRepository extends Mock implements AuthRepository {}

const _session = Session(
  token: 'demo',
  user: User(id: 2, email: 'staff@test.com', displayName: 'Dusty', role: UserRole.ranchStaff),
);

void main() {
  late _MockRepository repository;

  setUp(() => repository = _MockRepository());

  SessionBloc build({Session? initial}) => SessionBloc(
    login: LoginUseCase(repository),
    logout: LogoutUseCase(repository),
    initialSession: initial,
  );

  test('starts authenticated with a restored session', () {
    expect(build(initial: _session).state.isAuthenticated, isTrue);
    expect(build().state.status, SessionStatus.unauthenticated);
  });

  blocTest<SessionBloc, SessionState>(
    'signs out back to unauthenticated',
    setUp: () => when(() => repository.logout()).thenAnswer((_) async {}),
    build: () => build(initial: _session),
    act: (bloc) => bloc.add(const SessionLogoutRequested()),
    expect: () => [const SessionState()],
  );

  blocTest<SessionBloc, SessionState>(
    'reports a failed sign-in',
    setUp: () => when(
      () => repository.login(any()),
    ).thenAnswer((_) async => const Failed(UnauthorizedFailure())),
    build: build,
    act: (bloc) => bloc.add(const SessionLoginRequested('nobody@test.com')),
    expect: () => [
      const SessionState(status: SessionStatus.authenticating, pendingEmail: 'nobody@test.com'),
      const SessionState(status: SessionStatus.unauthenticated, failure: UnauthorizedFailure()),
    ],
  );
}
