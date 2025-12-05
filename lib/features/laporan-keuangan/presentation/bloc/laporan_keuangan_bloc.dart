import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/pemasukan_detail_entity.dart';
import '../../domain/entities/pengeluaran_detail_entity.dart';
import '../../domain/entities/laporan_summary_entity.dart';
import '../../domain/usecases/get_all_pemasukan_usecase.dart';
import '../../domain/usecases/get_all_pengeluaran_usecase.dart';
import '../../domain/usecases/get_laporan_summary_usecase.dart';
import '../../domain/usecases/generate_pdf_laporan_usecase.dart';

part 'laporan_keuangan_event.dart';
part 'laporan_keuangan_state.dart';

class LaporanKeuanganBloc
    extends Bloc<LaporanKeuanganEvent, LaporanKeuanganState> {
  final GetAllPemasukanUseCase getAllPemasukanUseCase;
  final GetAllPengeluaranUseCase getAllPengeluaranUseCase;
  final GetLaporanSummaryUseCase getLaporanSummaryUseCase;
  final GeneratePdfLaporanUseCase generatePdfLaporanUseCase;

  // Store current laporan for PDF generation
  LaporanSummaryEntity? _currentLaporan;

  LaporanKeuanganBloc({
    required this.getAllPemasukanUseCase,
    required this.getAllPengeluaranUseCase,
    required this.getLaporanSummaryUseCase,
    required this.generatePdfLaporanUseCase,
  }) : super(LaporanKeuanganInitial()) {
    on<LoadPemasukanListEvent>(_onLoadPemasukanList);
    on<LoadPengeluaranListEvent>(_onLoadPengeluaranList);
    on<LoadLaporanSummaryEvent>(_onLoadLaporanSummary);
    on<GeneratePdfEvent>(_onGeneratePdf);
  }

  Future<void> _onLoadPemasukanList(
    LoadPemasukanListEvent event,
    Emitter<LaporanKeuanganState> emit,
  ) async {
    emit(LaporanKeuanganLoading());

    final result = await getAllPemasukanUseCase(
      kategori: event.kategori,
      tanggalMulai: event.tanggalMulai,
      tanggalAkhir: event.tanggalAkhir,
    );

    result.fold(
      (failure) => emit(LaporanKeuanganError(failure.message)),
      (pemasukanList) => emit(
        PemasukanListLoaded(
          pemasukanList: pemasukanList,
          kategori: event.kategori,
          tanggalMulai: event.tanggalMulai,
          tanggalAkhir: event.tanggalAkhir,
        ),
      ),
    );
  }

  Future<void> _onLoadPengeluaranList(
    LoadPengeluaranListEvent event,
    Emitter<LaporanKeuanganState> emit,
  ) async {
    emit(LaporanKeuanganLoading());

    final result = await getAllPengeluaranUseCase(
      kategori: event.kategori,
      tanggalMulai: event.tanggalMulai,
      tanggalAkhir: event.tanggalAkhir,
    );

    result.fold(
      (failure) => emit(LaporanKeuanganError(failure.message)),
      (pengeluaranList) => emit(
        PengeluaranListLoaded(
          pengeluaranList: pengeluaranList,
          kategori: event.kategori,
          tanggalMulai: event.tanggalMulai,
          tanggalAkhir: event.tanggalAkhir,
        ),
      ),
    );
  }

  Future<void> _onLoadLaporanSummary(
    LoadLaporanSummaryEvent event,
    Emitter<LaporanKeuanganState> emit,
  ) async {
    emit(LaporanKeuanganLoading());

    final result = await getLaporanSummaryUseCase(
      tanggalMulai: event.tanggalMulai,
      tanggalAkhir: event.tanggalAkhir,
      jenisList: event.jenisLaporan,
    );

    result.fold((failure) => emit(LaporanKeuanganError(failure.message)), (
      laporan,
    ) {
      _currentLaporan = laporan; // Store for PDF generation
      emit(LaporanSummaryLoaded(laporan));
    });
  }

  Future<void> _onGeneratePdf(
    GeneratePdfEvent event,
    Emitter<LaporanKeuanganState> emit,
  ) async {
    if (_currentLaporan == null) {
      emit(const LaporanKeuanganError('Tidak ada data laporan untuk dicetak'));
      return;
    }

    emit(PdfGenerating());

    final result = await generatePdfLaporanUseCase(laporan: _currentLaporan!);

    result.fold(
      (failure) => emit(LaporanKeuanganError(failure.message)),
      (pdfFile) => emit(PdfGenerated(pdfFile)),
    );
  }
}
