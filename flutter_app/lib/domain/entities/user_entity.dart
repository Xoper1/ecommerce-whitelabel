import 'package:equatable/equatable.dart';
import 'client_entity.dart';

class UserEntity extends Equatable {
  final int id;
  final String email;
  final String name;
  final ClientEntity client;

  const UserEntity({
    required this.id,
    required this.email,
    required this.name,
    required this.client,
  });

  @override
  List<Object?> get props => [id, email, name, client];
}
