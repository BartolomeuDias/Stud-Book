import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/auth_usecases.dart';

sealed class SessionEvent extends Equatable {
  const SessionEvent();

  @override
  List<Object?> get props => [];
}

final class SessionLoginRequested extends SessionEvent {
  const SessionLoginRequested(this.email);

  final String email;

  @override
  List<Object?> get props => [email];
}

final class SessionLogoutRequested extends SessionEvent {
  const SessionLogoutRequested();
}

enum SessionStatus { unauthenticated, authenticating, authenticated }

class SessionState extends Equatable {
  const SessionState({
    this.status = SessionStatus.unauthenticated,
    this.session,
    this.pendingEmail,
    this.failure,
  });

  final SessionStatus status;
  final Session? session;
  final String? pendingEmail;
  final Failure? failure;

  User? get user => session?.user;
  bool get isAuthenticated => status == SessionStatus.authenticated;

  @override
  List<Object?> get props => [status, session, pendingEmail, failure];
}

class SessionBloc extends Bloc<SessionEvent, SessionState> {
  SessionBloc({required LoginUseCase login, Session? initialSession, required LogoutUseCase logout})
    : _login = login,
      _logout = logout,
      super(
        initialSession == null
            ? const SessionState()
            : SessionState(status: SessionStatus.authenticated, session: initialSession),
      ) {
    on<SessionLoginRequested>(_onLogin);
    on<SessionLogoutRequested>(_onLogout);
  }

  final LoginUseCase _login;
  final LogoutUseCase _logout;

  Future<void> _onLogin(SessionLoginRequested event, Emitter<SessionState> emit) async {
    emit(SessionState(status: SessionStatus.authenticating, pendingEmail: event.email));
    final result = await _login(event.email);
    emit(
      result.fold(
        (failure) => SessionState(status: SessionStatus.unauthenticated, failure: failure),
        (session) => SessionState(status: SessionStatus.authenticated, session: session),
      ),
    );
  }

  Future<void> _onLogout(SessionLogoutRequested event, Emitter<SessionState> emit) async {
    await _logout();
    emit(const SessionState(status: SessionStatus.unauthenticated));
  }
}
