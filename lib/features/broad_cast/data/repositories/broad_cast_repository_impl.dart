import 'package:jawara_pintar_mobile_version/features/broad_cast/data/data_sources/broad_cast_remote_data_source_impl.dart';

import '../../domain/entities/broadcast.dart';
import '../../domain/repositories/broadcast_repository.dart';
import '../models/broadcast_model.dart';


class BroadCastRepositoryImpl implements BroadcastRepository {
final BroadCastRemoteDataSource remote;


BroadCastRepositoryImpl(this.remote);


@override
Future<List<Broadcast>> getAllBroadcast() async {
return await remote.getAllBroadcast();
}


@override
Future<void> addBroadcast(Broadcast data) async {
final model = BroadcastModel(
id: data.id,
judul: data.judul,
isiPesan: data.isiPesan,
tanggalPublikasi: data.tanggalPublikasi,
lampiranGambar: data.lampiranGambar,
lampiranDokumen: data.lampiranDokumen,
createdBy: data.createdBy, title: '', content: '',
);


await remote.addBroadcast(model);
}
}