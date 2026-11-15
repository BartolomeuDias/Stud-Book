import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_config.dart';
import '../../domain/entities/user.dart';
import '../models/session_model.dart';

class AuthRemoteDataSource {
  const AuthRemoteDataSource(this._client);

  static const _emailKey = 'email';

  final ApiClient _client;

  Future<Session> login(String email) async {
    final json = await _client.post(ApiPaths.login, body: {_emailKey: email});
    return SessionModel.fromJson(json as Map<String, dynamic>);
  }
}

class AuthLocalDataSource {
  const AuthLocalDataSource(this._preferences);

  static const _sessionKey = 'studbook.session';

  final SharedPreferences _preferences;

  Session? read() {
    final raw = _preferences.getString(_sessionKey);
    if (raw == null) return null;
    try {
      return SessionModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } on Object {
      return null;
    }
  }

  Future<void> write(Session session) =>
      _preferences.setString(_sessionKey, jsonEncode(SessionModel.toJson(session)));

  Future<void> clear() => _preferences.remove(_sessionKey);
}
