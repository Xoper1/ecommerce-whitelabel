import 'package:equatable/equatable.dart';

class ClientEntity extends Equatable {
  final int id;
  final String name;
  final String? logoUrl;
  final String? primaryColor;

  const ClientEntity({
    required this.id,
    required this.name,
    this.logoUrl,
    this.primaryColor,
  });

  @override
  List<Object?> get props => [id, name, logoUrl, primaryColor];
}
