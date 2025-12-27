import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jawara_pintar_mobile_version/features/dashboard-kependudukan/domain/entities/kependudukan_entity.dart';
import 'package:jawara_pintar_mobile_version/features/dashboard-kependudukan/domain/repositories/dashboard_repository.dart';
import 'package:jawara_pintar_mobile_version/features/dashboard-kependudukan/domain/usecases/get_dashboard_kependudukan_usecase.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_dashboard_kependudukan_usecase_test.mocks.dart';

@GenerateMocks([DashboardKependudukanRepository])
void main() {
  late GetDashboardKependudukanUseCase usecase;
  late MockDashboardKependudukanRepository mockRepository;

  setUp(() {
    mockRepository = MockDashboardKependudukanRepository();
    usecase = GetDashboardKependudukanUseCase(mockRepository);
  });

  const tDashboardKependudukanEntity = DashboardKependudukanEntity(
    totalKeluarga: 10,
    totalPenduduk: 40,
    statusPenduduk: {},
    jenisKelamin: {},
    pekerjaanPenduduk: {},
    peranDalamKeluarga: {},
    agama: {},
    pendidikan: {},
  );

  test('should get dashboard kependudukan summary from the repository', () async {
    // Arrange
    when(mockRepository.getDashboardKependudukan())
        .thenAnswer((_) async => const Right(tDashboardKependudukanEntity));

    // Act
    final result = await usecase();

    // Assert
    expect(result, const Right(tDashboardKependudukanEntity));
    verify(mockRepository.getDashboardKependudukan());
    verifyNoMoreInteractions(mockRepository);
  });
}
