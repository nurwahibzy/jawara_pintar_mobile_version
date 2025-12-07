import '../../domain/entities/log_aktivitas.dart';

class LogAktivitasModel extends LogAktivitas {
  const LogAktivitasModel({
    required super.id,
    required super.tableName,
    required super.action,
    required super.role,
    super.description,
    required super.changedAt,
  });

  factory LogAktivitasModel.fromJson(Map<String, dynamic> json) {
    return LogAktivitasModel(
      id: json['id'],
      tableName: json['table_name'] as String,
      action: json['action'] as String,
      role: json['role'] as String?,
      description: json['description'] as String?,
      changedAt: DateTime.parse(json['changed_at'] as String),
    );
  }
}
