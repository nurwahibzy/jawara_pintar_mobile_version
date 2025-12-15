import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/penerimaan_warga_model.dart';
import 'penerimaan_warga_remote_data_source.dart';


class PenerimaanWargaRemoteDataSourceImpl
implements PenerimaanWargaRemoteDataSource {
final SupabaseClient client;


PenerimaanWargaRemoteDataSourceImpl(this.client);


@override
Future<List<PenerimaanWargaModel>> getAll() async {
final response = await client
.from('penerimaan_warga')
.select()
.order('created_at');


return (response as List)
.map((e) => PenerimaanWargaModel.fromJson(e))
.toList();
}
}