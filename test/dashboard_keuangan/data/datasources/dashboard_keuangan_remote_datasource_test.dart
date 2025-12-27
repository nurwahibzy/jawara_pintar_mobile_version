import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:jawara_pintar_mobile_version/features/dashboard-keuangan/data/datasources/dashboard_remote_datasource.dart';

import 'dashboard_keuangan_remote_datasource_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<DashboardRemoteDataSource>(),
])
void main() {
  late MockDashboardRemoteDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockDashboardRemoteDataSource();
  });

  group('DashboardKeuanganRemoteDataSource', () {
    const tYear = '2024';

    test('POSITIVE: getTotalPemasukanByYear should return total pemasukan', () async {
      // Arrange
      when(mockDataSource.getTotalPemasukanByYear(tYear)).thenAnswer((_) async => 5000000.0);

      // Act
      final result = await mockDataSource.getTotalPemasukanByYear(tYear);

      // Assert
      expect(result, 5000000.0);
      verify(mockDataSource.getTotalPemasukanByYear(tYear));
    });

    test('POSITIVE: getTotalPengeluaranByYear should return total pengeluaran', () async {
      // Arrange
      when(mockDataSource.getTotalPengeluaranByYear(tYear)).thenAnswer((_) async => 2000000.0);

      // Act
      final result = await mockDataSource.getTotalPengeluaranByYear(tYear);

      // Assert
      expect(result, 2000000.0);
      verify(mockDataSource.getTotalPengeluaranByYear(tYear));
    });
  });
}
