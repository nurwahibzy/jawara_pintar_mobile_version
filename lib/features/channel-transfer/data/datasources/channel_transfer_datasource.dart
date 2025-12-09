import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/services/supabase_service.dart';
import '../models/channel_transfer_model.dart';

abstract class TransferChannelRemoteDataSource {
  Future<List<TransferChannelModel>> getAllChannels();
  Future<TransferChannelModel?> getChannelById(int id);
  Future<void> createChannel(TransferChannelModel model);
  Future<void> updateChannel(TransferChannelModel model);
  Future<void> deleteChannel(int id);
  Future<String?> uploadQr(File file, {String? oldUrl});
  Future<String?> uploadThumbnail(File file, {String? oldUrl});
}

class TransferChannelRemoteDataSourceImpl
    implements TransferChannelRemoteDataSource {
  final SupabaseClient client;

  TransferChannelRemoteDataSourceImpl() : client = SupabaseService.client;

  @override
  Future<List<TransferChannelModel>> getAllChannels() async {
    final response = await client.from('transfer_channels').select();
    final dataList = List<Map<String, dynamic>>.from(response);
    return dataList.map((e) => TransferChannelModel.fromMap(e)).toList();
  }

  @override
  Future<TransferChannelModel?> getChannelById(int id) async {
    final response = await client
        .from('transfer_channels')
        .select()
        .eq('id', id)
        .maybeSingle();

    if (response == null) return null;
    return TransferChannelModel.fromMap(Map<String, dynamic>.from(response));
  }

  @override
  Future<void> createChannel(TransferChannelModel model) async {
    await client
        .from('transfer_channels')
        .insert(model.toMap(forUpdate: false));
  }

  @override
  Future<void> updateChannel(TransferChannelModel model) async {
    if (model.id == null) throw Exception("ID tidak boleh null saat update");
    await client
        .from('transfer_channels')
        .update(model.toMap(forUpdate: true))
        .eq('id', model.id!);
  }

  @override
  Future<void> deleteChannel(int id) async {
    await client.from('transfer_channels').delete().eq('id', id);
  }

  @override
  Future<String?> uploadQr(File file, {String? oldUrl}) async {
    return _uploadFile(file, 'transfer_channel_qr', oldUrl: oldUrl);
  }

  @override
  Future<String?> uploadThumbnail(File file, {String? oldUrl}) async {
    return _uploadFile(file, 'transfer_channel_thumbnail', oldUrl: oldUrl);
  }

  Future<String?> _uploadFile(
    File file,
    String bucket, {
    String? oldUrl,
  }) async {
    try {
      String fileName;
      if (oldUrl != null && oldUrl.isNotEmpty) {
        final uri = Uri.parse(oldUrl);
        final segments = uri.pathSegments;
        final fileIndex = segments.indexOf(bucket) + 1;
        fileName = segments[fileIndex];
      } else {
        fileName =
            '${bucket}_${DateTime.now().millisecondsSinceEpoch}_${file.uri.pathSegments.last}';
      }

      final bytes = await file.readAsBytes();

      await client.storage
          .from(bucket)
          .uploadBinary(
            fileName,
            bytes,
            fileOptions: const FileOptions(contentType: 'image/*'),
          );

      final publicUrl = client.storage.from(bucket).getPublicUrl(fileName);
      return publicUrl;
    } catch (e) {
      throw Exception('Gagal upload file: $e');
    }
  }
}