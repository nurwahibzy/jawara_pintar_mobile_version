import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/injections/injection.dart';
import '../../domain/usecases/get_all_pemasukan_usecase.dart';
import '../../domain/usecases/get_all_pengeluaran_usecase.dart';
import '../../domain/usecases/get_laporan_summary_usecase.dart';
import '../../domain/usecases/generate_pdf_laporan_usecase.dart';
import '../bloc/laporan_keuangan_bloc.dart';
import 'pemasukan_list_page.dart';
import 'pengeluaran_list_page.dart';
import 'package:jawara_pintar_mobile_version/core/theme/app_colors.dart';

class LaporanKeuanganMainPage extends StatelessWidget {
  const LaporanKeuanganMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LaporanKeuanganBloc(
        getAllPemasukanUseCase: sl.get<GetAllPemasukanUseCase>(),
        getAllPengeluaranUseCase: sl.get<GetAllPengeluaranUseCase>(),
        getLaporanSummaryUseCase: sl.get<GetLaporanSummaryUseCase>(),
        generatePdfLaporanUseCase: sl.get<GeneratePdfLaporanUseCase>(),
      ),
      child: const _LaporanKeuanganMainPageContent(),
    );
  }
}

class _LaporanKeuanganMainPageContent extends StatelessWidget {
  const _LaporanKeuanganMainPageContent();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
              decoration: BoxDecoration(
                color: AppColors.primary,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Laporan Keuangan',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Lihat semua transaksi keuangan',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Tab Bar
            Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                indicator: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey[600],
                labelStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.normal,
                ),
                tabs: const [
                  Tab(
                    icon: Icon(Icons.trending_up, size: 20),
                    text: 'Pemasukan',
                  ),
                  Tab(
                    icon: Icon(Icons.trending_down, size: 20),
                    text: 'Pengeluaran',
                  ),
                ],
              ),
            ),

            // Tab Views
            const Expanded(
              child: TabBarView(
                children: [PemasukanListPage(), PengeluaranListPage()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
