import '../../domain/entities/client.dart';

abstract final class ClientModel {
  static const _id = 'id';
  static const _name = 'name';
  static const _type = 'type';
  static const _types = {'Stable': ClientType.stable, 'PrivateOwner': ClientType.privateOwner};

  static Client fromJson(Map<String, dynamic> json) => Client(
    id: json[_id] as int,
    name: json[_name] as String,
    type: _types[json[_type]] ?? (throw FormatException('Unknown client type: ${json[_type]}')),
  );
}
