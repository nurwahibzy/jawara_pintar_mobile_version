import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:jawara_pintar_mobile_version/features/broad_cast/domain/entities/broadcast.dart';
import 'package:jawara_pintar_mobile_version/features/broad_cast/domain/repositories/broadcast_repository.dart';
import 'package:jawara_pintar_mobile_version/features/broad_cast/domain/use_cases/get_broadcast_list.dart';

class MockBroadcastRepository extends Mock
    implements BroadcastRepository {
      GetBroadcastUseCase() {}}

void main() {
  late  GetBroadcastUseCase usecase;
  late MockBroadcastRepository repository;

  setUp(() {
    repository = MockBroadcastRepository();
    usecase =  GetBroadcastUseCase(repository);
  });

  final testBroadcast = [
    Broadcast(
      id: 1,
      title: 'Judul',
      content: 'Isi broadcast', judul: '', isiPesan: '',  lampiranDokumen: '', lampiranGambar: '', tanggalPublikasi: DateTime.now(), createdBy: 1,
    ),
  ];

  test('should get list broadcast from repository', () async {
    // arrange
    when(() => repository.GetBroadcastUseCase())
        .thenAnswer((_) async => testBroadcast);

    // act
    final result = await usecase();

    // assert
    expect(result, testBroadcast);
    verify(() => repository.GetBroadcastUseCase()).called(1);
  });
}



