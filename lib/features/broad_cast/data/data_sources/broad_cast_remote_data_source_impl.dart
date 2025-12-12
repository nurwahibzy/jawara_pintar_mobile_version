import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/broadcast.dart';
import '../models/broadcast_model.dart';


abstract class BroadCastRemoteDataSource {
Future<List<BroadcastModel>> getAllBroadcast();
Future<void> addBroadcast(BroadcastModel model);
}


class BroadCastRemoteDataSourceImpl implements BroadCastRemoteDataSource {
final SupabaseClient client;
BroadCastRemoteDataSourceImpl(this.client);


@override
Future<List<BroadcastModel>> getAllBroadcast() async {
final response = await client.from('broadcast').select();


return response
.map((e) => BroadcastModel.fromJson(e))
.toList();
}


@override
Future<void> addBroadcast(BroadcastModel model) async {
await client.from('broadcast').insert(model.toJson());
}
}