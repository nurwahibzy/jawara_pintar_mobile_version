import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:jawara_pintar_mobile_version/core/errors/failure.dart';
import '../entities/warga.dart';
import '../repositories/warga_repository.dart';

class FilterWarga {
  final WargaRepository repository;

  FilterWarga(this.repository);

  Future<Either<Failure, List<Warga>>> call(FilterWargaParams params) async {
    return await repository.filterWarga(params);
  }
}

class FilterWargaParams extends Equatable {
  final String? nama;
  final String? jenisKelamin;
  final String? status;
  final String? keluarga;

  const FilterWargaParams({
    this.nama,
    this.jenisKelamin,
    this.status,
    this.keluarga,
  });

  @override
  List<Object?> get props => [nama, jenisKelamin, status, keluarga];
}
