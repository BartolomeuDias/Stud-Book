import 'package:equatable/equatable.dart';

enum UserRole { client, ranchStaff }

class User extends Equatable {
  const User({
    required this.id,
    required this.email,
    required this.displayName,
    required this.role,
  });

  final int id;
  final String email;
  final String displayName;
  final UserRole role;

  @override
  List<Object?> get props => [id, email, displayName, role];
}

class Session extends Equatable {
  const Session({required this.token, required this.user});

  final String token;
  final User user;

  @override
  List<Object?> get props => [token, user];
}
