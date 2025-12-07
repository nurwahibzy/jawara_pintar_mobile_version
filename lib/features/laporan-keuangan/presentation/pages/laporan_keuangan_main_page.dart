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

class _LaporanKeuanganMainPageContent extends StatefulWidget {
  const _LaporanKeuanganMainPageContent();

  @override
  State<_LaporanKeuanganMainPageContent> createState() =>
      _LaporanKeuanganMainPageContentState();
}

class _LaporanKeuanganMainPageContentState
    extends State<_LaporanKeuanganMainPageContent>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Custom Tab Bar
          Container(
            margin: const EdgeInsets.all(16),
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: AnimatedBuilder(
              animation: _tabController,
              builder: (context, child) {
                return Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _tabController.animateTo(0),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          decoration: BoxDecoration(
                            color: _tabController.index == 0
                                ? AppColors.primary
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.trending_up,
                                size: 20,
                                color: _tabController.index == 0
                                    ? Colors.white
                                    : Colors.grey[600],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Pemasukan',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: _tabController.index == 0
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                  color: _tabController.index == 0
                                      ? Colors.white
                                      : Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _tabController.animateTo(1),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          decoration: BoxDecoration(
                            color: _tabController.index == 1
                                ? AppColors.primary
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.trending_down,
                                size: 20,
                                color: _tabController.index == 1
                                    ? Colors.white
                                    : Colors.grey[600],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Pengeluaran',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: _tabController.index == 1
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                  color: _tabController.index == 1
                                      ? Colors.white
                                      : Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          // Tab Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [PemasukanListPage(), PengeluaranListPage()],
            ),
          ),
        ],
      ),
    );
  }
}
