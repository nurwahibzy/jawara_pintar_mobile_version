import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:jawara_pintar_mobile_version/features/dashboard-kependudukan/data/datasources/dashboard_remote_datasource.dart';

import 'dashboard_kependudukan_remote_datasource_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<DashboardKependudukanRemoteDataSource>(),
])
void main() {
  late MockDashboardKependudukanRemoteDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockDashboardKependudukanRemoteDataSource();
  });

  group('DashboardKependudukanRemoteDataSource', () {
    test('POSITIVE: getTotalPenduduk should return count', () async {
      // Arrange
      when(mockDataSource.getTotalPenduduk()).thenAnswer((_) async => 200);

      // Act
      final result = await mockDataSource.getTotalPenduduk();

      // Assert
      expect(result, 200);
      verify(mockDataSource.getTotalPenduduk());
    });

    test('POSITIVE: getStatusPenduduk should return status map', () async {
      // Arrange
      final tData = {'Aktif': 150, 'Nonaktif': 50};
      when(mockDataSource.getStatusPenduduk()).thenAnswer((_) async => tData);

      // Act
      final result = await mockDataSource.getStatusPenduduk();

      // Assert
      expect(result, tData);
      verify(mockDataSource.getStatusPenduduk());
    });
  });
}
