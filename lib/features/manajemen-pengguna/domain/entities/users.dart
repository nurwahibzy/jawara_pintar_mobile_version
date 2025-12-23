import 'package:equatable/equatable.dart';

class Users extends Equatable {
  final int? id;
  final int wargaId;
  final String? nama;
  final String role;
  final String status;
  final String authId;
  final DateTime createdAt;

  const Users({
    required this.id,
    required this.wargaId,
    required this.nama,
    required this.role,
    required this.status,
    required this.authId,
    required this.createdAt,
  });

  // PERBAIKAN COPYWITH
  Users copyWith({
    int? id,
    int? wargaId,
    String? nama,
    String? role,
    String? status,
    String? authId,
    DateTime? createdAt,
  }) {
    return Users(
      id: id ?? this.id,
      wargaId: wargaId ?? this.wargaId,
      nama: nama ?? this.nama,
      role: role ?? this.role,
      status: status ?? this.status,
      authId: authId ?? this.authId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, wargaId, nama, role, status, authId, createdAt];
}