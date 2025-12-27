import 'package:flutter_test/flutter_test.dart';
import 'package:jawara_pintar_mobile_version/features/dashboard-kependudukan/domain/entities/kependudukan_entity.dart';

void main() {
  const tDashboardKependudukanEntity = DashboardKependudukanEntity(
    totalKeluarga: 10,
    totalPenduduk: 40,
    statusPenduduk: {'Aktif': 40},
    jenisKelamin: {'Laki-laki': 20},
    pekerjaanPenduduk: {},
    peranDalamKeluarga: {},
    agama: {},
    pendidikan: {},
  );

  test('should support value equality', () {
    const tDashboardKependudukanEntity2 = DashboardKependudukanEntity(
      totalKeluarga: 10,
      totalPenduduk: 40,
      statusPenduduk: {'Aktif': 40},
      jenisKelamin: {'Laki-laki': 20},
      pekerjaanPenduduk: {},
      peranDalamKeluarga: {},
      agama: {},
      pendidikan: {},
    );

    expect(tDashboardKependudukanEntity, equals(tDashboardKependudukanEntity2));
  });
}
