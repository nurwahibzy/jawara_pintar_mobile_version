import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/laporan_cetak_entity.dart';
import '../../domain/usecases/generate_pdf_usecase.dart';
import '../../domain/usecases/get_laporan_data_usecase.dart';
import '../../domain/usecases/share_pdf_usecase.dart';
import 'cetak_laporan_event.dart';
import 'cetak_laporan_state.dart';

class CetakLaporanBloc extends Bloc<CetakLaporanEvent, CetakLaporanState> {
  final GetLaporanDataUseCase getLaporanDataUseCase;
  final GeneratePdfUseCase generatePdfUseCase;
  final SharePdfUseCase sharePdfUseCase;

  LaporanCetakEntity? _currentLaporan;
  File? _currentPdfFile;

  CetakLaporanBloc({
    required this.getLaporanDataUseCase,
    required this.generatePdfUseCase,
    required this.sharePdfUseCase,
  }) : super(CetakLaporanInitial()) {
    on<LoadLaporanDataEvent>(_onLoadLaporanData);
    on<GeneratePdfEvent>(_onGeneratePdf);
    on<SharePdfEvent>(_onSharePdf);
  }

  Future<void> _onLoadLaporanData(
    LoadLaporanDataEvent event,
    Emitter<CetakLaporanState> emit,
  ) async {
    emit(CetakLaporanLoading());

    final result = await getLaporanDataUseCase(
      tanggalMulai: event.tanggalMulai,
      tanggalAkhir: event.tanggalAkhir,
      jenisLaporan: event.jenisLaporan,
    );

    result.fold((failure) => emit(CetakLaporanError(failure.message)), (
      laporan,
    ) {
      _currentLaporan = laporan;
      emit(LaporanDataLoaded(laporan));
    });
  }

  Future<void> _onGeneratePdf(
    GeneratePdfEvent event,
    Emitter<CetakLaporanState> emit,
  ) async {
    if (_currentLaporan == null) {
      emit(const CetakLaporanError('Tidak ada data laporan'));
      return;
    }

    emit(PdfGenerating());

    final result = await generatePdfUseCase(laporan: _currentLaporan!);

    result.fold((failure) => emit(CetakLaporanError(failure.message)), (
      pdfFile,
    ) {
      _currentPdfFile = pdfFile;
      emit(PdfGenerated(pdfFile));
    });
  }

  Future<void> _onSharePdf(
    SharePdfEvent event,
    Emitter<CetakLaporanState> emit,
  ) async {
    if (_currentPdfFile == null) {
      emit(const CetakLaporanError('PDF belum dibuat'));
      return;
    }

    final result = await sharePdfUseCase(pdfFile: _currentPdfFile!);

    result.fold(
      (failure) => emit(CetakLaporanError(failure.message)),
      (_) => emit(PdfShared()),
    );
  }
}
