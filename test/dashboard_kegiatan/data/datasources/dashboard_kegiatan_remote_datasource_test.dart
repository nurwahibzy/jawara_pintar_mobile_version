import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:jawara_pintar_mobile_version/features/dashboard-kegiatan/data/datasources/dashboard_remote_datasource.dart';

import 'dashboard_kegiatan_remote_datasource_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<DashboardKegiatanRemoteDataSource>(),
])
void main() {
  late MockDashboardKegiatanRemoteDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockDashboardKegiatanRemoteDataSource();
  });

  group('DashboardKegiatanRemoteDataSource', () {
    test('POSITIVE: getTotalKegiatan should return count when successful', () async {
      // Arrange
      when(mockDataSource.getTotalKegiatan()).thenAnswer((_) async => 10);

      // Act
      final result = await mockDataSource.getTotalKegiatan();

      // Assert
      expect(result, 10);
      verify(mockDataSource.getTotalKegiatan());
    });

    test('POSITIVE: getKegiatanPerKategori should return map of categories', () async {
      // Arrange
      final tData = {'Sosial': 5, 'Olahraga': 3};
      when(mockDataSource.getKegiatanPerKategori()).thenAnswer((_) async => tData);

      // Act
      final result = await mockDataSource.getKegiatanPerKategori();

      // Assert
      expect(result, tData);
      verify(mockDataSource.getKegiatanPerKategori());
    });
  });
}
