import 'dart:io';
import 'package:equatable/equatable.dart';
import '../../domain/entities/laporan_cetak_entity.dart';

abstract class CetakLaporanState extends Equatable {
  const CetakLaporanState();

  @override
  List<Object?> get props => [];
}

class CetakLaporanInitial extends CetakLaporanState {}

class CetakLaporanLoading extends CetakLaporanState {}

class LaporanDataLoaded extends CetakLaporanState {
  final LaporanCetakEntity laporan;

  const LaporanDataLoaded(this.laporan);

  @override
  List<Object?> get props => [laporan];
}

class PdfGenerating extends CetakLaporanState {}

class PdfGenerated extends CetakLaporanState {
  final File pdfFile;

  const PdfGenerated(this.pdfFile);

  @override
  List<Object?> get props => [pdfFile];
}

class PdfShared extends CetakLaporanState {}

class CetakLaporanError extends CetakLaporanState {
  final String message;

  const CetakLaporanError(this.message);

  @override
  List<Object?> get props => [message];
}
