import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/services/supabase_service.dart';
import '../models/log_aktivitas_model.dart';

abstract class LogAktivitasDatasource {
  Future<List<LogAktivitasModel>> getAllLogAktivitas();
}

class LogAktivitasDatasourceImplementation extends LogAktivitasDatasource {
  final String _table = 'log_aktivitas_view';
  final SupabaseClient client;

  LogAktivitasDatasourceImplementation() : client = SupabaseService.client;
  @override
  Future<List<LogAktivitasModel>> getAllLogAktivitas() async {
    try {
      final response = await client.from(_table).select();
      final dataList = List<Map<String, dynamic>>.from(response);
      // print(dataList);
      return dataList.map((data) => LogAktivitasModel.fromJson(data)).toList();
    } catch (e) {
      rethrow;
    }
  }
}
