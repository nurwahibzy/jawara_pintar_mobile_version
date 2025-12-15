import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/failure.dart';
import '../../domain/entities/channel_transfer_entities.dart';
import '../../domain/repositories/channel_transfer_repository.dart';
import '../datasources/channel_transfer_datasource.dart';
import '../models/channel_transfer_model.dart';

class TransferChannelRepositoryImpl implements TransferChannelRepository {
  final TransferChannelRemoteDataSource remote;

  TransferChannelRepositoryImpl(this.remote);

  @override
  Future<Either<Failure, List<TransferChannel>>> getAllChannels() async {
    try {
      final models = await remote.getAllChannels();
      return Right(models.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TransferChannel>> getChannelById(int id) async {
    try {
      final response = await remote.getChannelById(id);
      if (response == null) return Left(ServerFailure('Channel not found'));
      return Right(response.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> createChannel(
    TransferChannel channel, {
    File? qrFile,
    File? thumbnailFile,
  }) async {
    try {
      final supabaseUser = Supabase.instance.client.auth.currentUser;
      if (supabaseUser == null) return Left(ServerFailure('User belum login'));

      final userRecord = await Supabase.instance.client
          .from('users')
          .select('id')
          .eq('auth_id', supabaseUser.id)
          .maybeSingle();

      if (userRecord == null) {
        return Left(ServerFailure('User tidak ditemukan di tabel users'));
      }

      final createdBy = userRecord['id'] as int;

      String? qrUrl = channel.qrUrl;
      String? thumbnailUrl = channel.thumbnailUrl;

      if (qrFile != null) qrUrl = await remote.uploadQr(qrFile);
      if (thumbnailFile != null) {
        thumbnailUrl = await remote.uploadThumbnail(thumbnailFile);
      }

      final model = TransferChannelModel.fromEntity(channel).copyWith(
        createdBy: createdBy,
        qrUrl: qrUrl,
        thumbnailUrl: thumbnailUrl,
      );

      await remote.createChannel(model);
      return const Right(true);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> updateChannel(
    TransferChannel channel, {
    File? qrFile,
    File? thumbnailFile,
  }) async {
    try {
      final supabaseUser = Supabase.instance.client.auth.currentUser;
      if (supabaseUser == null) return Left(ServerFailure('User belum login'));

      final userRecord = await Supabase.instance.client
          .from('users')
          .select('id')
          .eq('auth_id', supabaseUser.id)
          .maybeSingle();

      if (userRecord == null) {
        return Left(ServerFailure('User tidak ditemukan di tabel users'));
      }

      final createdBy = userRecord['id'] as int;

      String? qrUrl = channel.qrUrl;
      String? thumbnailUrl = channel.thumbnailUrl;

      if (qrFile != null) qrUrl = await remote.uploadQr(qrFile, oldUrl: qrUrl);
      if (thumbnailFile != null) {
        thumbnailUrl = await remote.uploadThumbnail(
          thumbnailFile,
          oldUrl: thumbnailUrl,
        );
      }

      final model = TransferChannelModel.fromEntity(channel).copyWith(
        createdBy: createdBy,
        qrUrl: qrUrl,
        thumbnailUrl: thumbnailUrl,
      );

      await remote.updateChannel(model);
      return const Right(true);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteChannel(int id) async {
    try {
      await remote.deleteChannel(id);
      return const Right(true);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<String?> uploadQr(File file, {String? oldUrl}) async {
    try {
      return await remote.uploadQr(file, oldUrl: oldUrl);
    } catch (e) {
      throw Exception('Gagal upload QR: $e');
    }
  }

  @override
  Future<String?> uploadThumbnail(File file, {String? oldUrl}) async {
    try {
      return await remote.uploadThumbnail(file, oldUrl: oldUrl);
    } catch (e) {
      throw Exception('Gagal upload Thumbnail: $e');
    }
  }
}