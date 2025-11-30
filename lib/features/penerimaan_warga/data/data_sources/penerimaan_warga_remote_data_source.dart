import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/penerimaan_warga_model.dart';

abstract class PenerimaanWargaRemoteDataSource {
  Future<List<PenerimaanWargaModel>> getPenerimaanWarga();
}

class PenerimaanWargaRemoteDataSourceImpl
    implements PenerimaanWargaRemoteDataSource {
  final http.Client client;

  PenerimaanWargaRemoteDataSourceImpl(this.client);

  @override
  Future<List<PenerimaanWargaModel>> getPenerimaanWarga() async {
    final response = await client.get(
      Uri.parse("https://api.example.com/penerimaan_warga"),
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data
          .map((json) => PenerimaanWargaModel.fromJson(json))
          .toList();
    } else {
      throw Exception("Gagal mengambil data");
    }
  }
}
