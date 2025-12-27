import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jawara_pintar_mobile_version/core/errors/failure.dart';
import 'package:jawara_pintar_mobile_version/features/dashboard-keuangan/domain/entities/keuangan_entity.dart';
import 'package:jawara_pintar_mobile_version/features/dashboard-keuangan/domain/repositories/dashboard_repository.dart';
import 'package:jawara_pintar_mobile_version/features/dashboard-keuangan/domain/usecases/get_dashboard_summary_usecase.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_dashboard_summary_usecase_test.mocks.dart';

@GenerateMocks([DashboardKeuanganRepository])
void main() {
  late GetDashboardSummaryUseCase usecase;
  late MockDashboardKeuanganRepository mockRepository;

  setUp(() {
    mockRepository = MockDashboardKeuanganRepository();
    usecase = GetDashboardSummaryUseCase(mockRepository);
  });

  const tYear = '2025';
  const tDashboardSummaryEntity = DashboardSummaryEntity(
    year: tYear,
    totalPemasukan: 1000000,
    totalPengeluaran: 500000,
    saldo: 500000,
    monthlyPemasukan: [],
    monthlyPengeluaran: [],
    kategoriPemasukan: {},
    kategoriPengeluaran: {},
    availableYears: [],
  );

  test('should get dashboard summary from the repository', () async {
    // Arrange
    when(mockRepository.getDashboardSummary(tYear))
        .thenAnswer((_) async => const Right(tDashboardSummaryEntity));

    // Act
    final result = await usecase(tYear);

    // Assert
    expect(result, const Right(tDashboardSummaryEntity));
    verify(mockRepository.getDashboardSummary(tYear));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return ValidationFailure when year is empty', () async {
    // Act
    final result = await usecase('');

    // Assert
    expect(result, isA<Left<Failure, DashboardSummaryEntity>>());
  });

  test('should return ValidationFailure when year is invalid', () async {
    // Act
    final result = await usecase('invalid');

    // Assert
    expect(result, isA<Left<Failure, DashboardSummaryEntity>>());
  });
}
