import 'package:jawara_pintar_mobile_version/features/broad_cast/data/models/broad_cast_model.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/broadcast_model.dart';

abstract class BroadcastRemoteDataSource {
  Future<void> insertBroadcast(BroadcastModel broadcast);
}

class BroadcastRemoteDataSourceImpl implements BroadcastRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  BroadcastRemoteDataSourceImpl({required this.client, required this.baseUrl});

  @override
  Future<void> insertBroadcast(BroadcastModel broadcast) async {
    final response = await client.post(
      Uri.parse('$baseUrl/broadcast'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(broadcast.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to insert broadcast');
    }
  }
}

// class BroadCastRemoteDataSourceImpl implements BroadCastRemoteDataSource {
//   const BroadCastRemoteDataSourceImpl();

//   Future<T> _run<T>(Future<T> Function() function) async {
//     try {
//       return await function();
//     } catch (e) {
//       rethrow;
//     }
//   }
// }
