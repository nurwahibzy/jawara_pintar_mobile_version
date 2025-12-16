import 'dart:io';


import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/pengeluaran.dart';
import '../../domain/entities/kategori_transaksi.dart';
import '../../domain/repositories/pengeluaran_repository.dart';
import '../datasources/remote_datasource.dart';
import '../models/pengeluaran_model.dart';

class PengeluaranRepositoryImpl implements PengeluaranRepository {
  final PengeluaranRemoteDataSource remote;
  

  PengeluaranRepositoryImpl(this.remote);

  // ================= Pengeluaran CRUD =================
  @override
  Future<Either<Failure, List<Pengeluaran>>> getAllPengeluaran() async {
    try {
      final models = await remote.getAllPengeluaran();
      final List<Pengeluaran> results = [];


      final uids = models
          .map((m) => (m.createdBy ?? '').toString())
          .where((u) => u.isNotEmpty)
          .toSet()
          .toList();

      final Map<String, String?> names = await remote.getNamesByUids(uids);

      for (var model in models) {
        final createdByUid = (model.createdBy ?? '').toString();
        final entity = Pengeluaran(
          id: model.id,
          judul: model.judul,
          kategoriTransaksiId: model.kategoriTransaksiId,
          nominal: model.nominal,
          tanggalTransaksi: model.tanggalTransaksi,
          buktiFoto: model.buktiFoto,
          keterangan: model.keterangan,
          createdBy: createdByUid,
          createdAt: model.createdAt,
        );

        final withName = entity.copyWith(createdByName: names[createdByUid]);
        results.add(withName);
      }

      return Right(results);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Pengeluaran>> getPengeluaranById(int id) async {
    try {
      final response = await remote.getPengeluaranById(id);

      if (response == null) {
        return Left(ServerFailure("Pengeluaran tidak ditemukan"));
      }

      final entity = response.toEntity().copyWith(
        createdByName: response.createdByName, 
      );

      return Right(entity);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> createPengeluaran(
    Pengeluaran pengeluaran, {
    String? buktiFoto,
  }) async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return Left(ServerFailure('User belum login'));

      final pengeluaranWithUser = pengeluaran.copyWith(
        createdBy: user.id,
      ); 

      await remote.createPengeluaran(
        PengeluaranModel.fromEntity(
          pengeluaranWithUser.copyWith(buktiFoto: buktiFoto),
        ),
      );
      return Right(true);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> updatePengeluaran(
    Pengeluaran pengeluaran,
  ) async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        return Left(ServerFailure('User belum login'));
      }

      await remote.updatePengeluaran(
        PengeluaranModel.fromEntity(pengeluaran.copyWith(createdBy: user.id)),
      );

      return Right(true);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deletePengeluaran(int id) async {
    try {
      await remote.deletePengeluaran(id);
      return Right(true);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

 @override
  Future<String?> uploadBukti(File file, {String? oldUrl}) async {
    try {
      final supabase = Supabase.instance.client;
      const bucket = 'pengeluaran';

      final user = supabase.auth.currentUser;
      if (user == null) throw Exception('User belum login');

      if (oldUrl != null && oldUrl.isNotEmpty) {
        final uri = Uri.parse(oldUrl);
        final segments = uri.pathSegments;
        final index = segments.indexOf(bucket) + 1;
        if (index > 0 && index < segments.length) {
          final oldFileName = segments[index];
          await supabase.storage.from(bucket).remove([oldFileName]);
        }
      }

      final fileName =
          'pengeluaran_${user.id}_${DateTime.now().millisecondsSinceEpoch}_${file.uri.pathSegments.last}';

      final bytes = await file.readAsBytes();
      await supabase.storage
          .from(bucket)
          .uploadBinary(
            fileName,
            bytes,
            fileOptions: const FileOptions(contentType: 'image/*'),
          );

      final publicUrl = supabase.storage.from(bucket).getPublicUrl(fileName);
      return publicUrl;
    } catch (e) {
      throw Exception('Gagal upload bukti: $e');
    }
  }

  @override
  Future<void> deleteBukti(String url) async {
    if (url.isEmpty) return;

    final supabase = Supabase.instance.client;
    final uri = Uri.parse(url);
    final segments = uri.pathSegments;
    final fileIndex = segments.indexOf('pengeluaran') + 1;
    if (fileIndex <= 0 || fileIndex >= segments.length) return;
    final fileName = segments[fileIndex];

    await supabase.storage.from('pengeluaran').remove([fileName]);
  }

  // ================= Kategori untuk Pengeluaran =================
  @override
  Future<Either<Failure, List<KategoriEntity>>> getKategoriPengeluaran() async {
    try {
      final result = await remote
          .getKategoriPengeluaran(); 
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}