import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jawara_pintar_mobile_version/features/dashboard-kegiatan/domain/entities/kegiatan_entity.dart';
import 'package:jawara_pintar_mobile_version/features/dashboard-kegiatan/domain/repositories/dashboard_repository.dart';
import 'package:jawara_pintar_mobile_version/features/dashboard-kegiatan/domain/usecases/get_dashboard_kegiatan_usecase.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_dashboard_kegiatan_usecase_test.mocks.dart';

@GenerateMocks([DashboardKegiatanRepository])
void main() {
  late GetDashboardKegiatanUseCase usecase;
  late MockDashboardKegiatanRepository mockRepository;

  setUp(() {
    mockRepository = MockDashboardKegiatanRepository();
    usecase = GetDashboardKegiatanUseCase(mockRepository);
  });

  const tDashboardKegiatanEntity = DashboardKegiatanEntity(
    totalKegiatan: 10,
    kegiatanPerKategori: {},
    kegiatanBerdasarkanWaktu: {},
    penanggungJawabTerbanyak: [],
    kegiatanPerBulan: [],
  );

  test('should get dashboard kegiatan summary from the repository', () async {
    // Arrange
    when(mockRepository.getDashboardKegiatan())
        .thenAnswer((_) async => const Right(tDashboardKegiatanEntity));

    // Act
    final result = await usecase();

    // Assert
    expect(result, const Right(tDashboardKegiatanEntity));
    verify(mockRepository.getDashboardKegiatan());
    verifyNoMoreInteractions(mockRepository);
  });
}
