import 'package:equatable/equatable.dart';

class LogAktivitas extends Equatable {
  final int? id;
  final String tableName;
  final String action;
  final String? role;
  final String? description;
  final DateTime changedAt;

  const LogAktivitas({
    required this.id,
    required this.tableName,
    required this.action,
    required this.role,
    this.description,
    required this.changedAt,
  });

  @override
  List<Object?> get props => [
    id,
    tableName,
    action,
    role,
    description,
    changedAt,
  ];
}
