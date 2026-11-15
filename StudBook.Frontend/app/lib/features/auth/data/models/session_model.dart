import '../../domain/entities/user.dart';

abstract final class _Keys {
  static const token = 'token';
  static const user = 'user';
  static const id = 'id';
  static const email = 'email';
  static const displayName = 'displayName';
  static const role = 'role';
}

abstract final class UserRoleCodec {
  static const _client = 'Client';
  static const _ranchStaff = 'RanchStaff';

  static UserRole decode(String value) => switch (value) {
    _client => UserRole.client,
    _ranchStaff => UserRole.ranchStaff,
    _ => throw FormatException('Unknown role: $value'),
  };

  static String encode(UserRole role) => switch (role) {
    UserRole.client => _client,
    UserRole.ranchStaff => _ranchStaff,
  };
}

abstract final class SessionModel {
  static Session fromJson(Map<String, dynamic> json) {
    final user = json[_Keys.user] as Map<String, dynamic>;
    return Session(
      token: json[_Keys.token] as String,
      user: User(
        id: user[_Keys.id] as int,
        email: user[_Keys.email] as String,
        displayName: user[_Keys.displayName] as String,
        role: UserRoleCodec.decode(user[_Keys.role] as String),
      ),
    );
  }

  static Map<String, dynamic> toJson(Session session) => {
    _Keys.token: session.token,
    _Keys.user: {
      _Keys.id: session.user.id,
      _Keys.email: session.user.email,
      _Keys.displayName: session.user.displayName,
      _Keys.role: UserRoleCodec.encode(session.user.role),
    },
  };
}
