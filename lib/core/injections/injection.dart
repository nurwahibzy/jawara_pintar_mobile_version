import 'package:get_it/get_it.dart';

// Import fitur
import '../../features/pengeluaran/data/datasources/remote_datasource.dart';
import '../../features/pengeluaran/data/repositories/pengeluaran_repository_implementation.dart';
import '../../features/pengeluaran/domain/repositories/pengeluaran_repository.dart';
import '../../features/pengeluaran/domain/usecases/create_pengeluaran.dart';
import '../../features/pengeluaran/domain/usecases/delete_pengeluaran.dart';

// Import Usecases 
import '../../features/pengeluaran/domain/usecases/get_all_pengeluaran.dart';
import '../../features/pengeluaran/domain/usecases/get_pengeluaran.dart';
import '../../features/pengeluaran/domain/usecases/update_pengeluaran.dart';

// Import Bloc 
import '../../features/pengeluaran/presentation/bloc/pengeluaran_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Datasource
  sl.registerLazySingleton<PengeluaranRemoteDataSource>(
    () => PengeluaranRemoteDataSourceImpl(),
  );

  // Repository
  sl.registerLazySingleton<PengeluaranRepository>(
    () => PengeluaranRepositoryImpl(sl()),
  );

  // Usecases
  sl.registerLazySingleton(() => GetPengeluaranList(sl()));
  sl.registerLazySingleton(() => GetPengeluaranById(sl()));
  sl.registerLazySingleton(() => CreatePengeluaran(sl()));
  sl.registerLazySingleton(() => UpdatePengeluaran(sl()));
  sl.registerLazySingleton(() => DeletePengeluaran(sl()));

  //Bloc
  sl.registerFactory(
    () => PengeluaranBloc(repository: sl<PengeluaranRepository>()),
  );
}