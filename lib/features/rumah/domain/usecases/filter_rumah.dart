import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:jawara_pintar_mobile_version/core/errors/failure.dart';
import '../entities/rumah.dart';
import '../repositories/rumah_repository.dart';

class FilterRumah {
  final RumahRepository repository;

  FilterRumah(this.repository);

  Future<Either<Failure, List<Rumah>>> call(FilterRumahParams params) async {
    return await repository.filterRumah(params);
  }
}

class FilterRumahParams extends Equatable {
  final String? alamat;
  final String? status;

  const FilterRumahParams({this.alamat, this.status});

  @override
  List<Object?> get props => [alamat, status];
}
