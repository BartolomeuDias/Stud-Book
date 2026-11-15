import 'package:equatable/equatable.dart';

enum ClientType { stable, privateOwner }

class Client extends Equatable {
  const Client({required this.id, required this.name, required this.type});

  final int id;
  final String name;
  final ClientType type;

  @override
  List<Object?> get props => [id, name, type];
}
