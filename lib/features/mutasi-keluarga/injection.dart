import 'package:get_it/get_it.dart';
import 'package:jawara_pintar_mobile_version/features/mutasi-keluarga/data/datasources/mutasi_keluarga_datasource.dart';
import 'package:jawara_pintar_mobile_version/features/mutasi-keluarga/data/repositories/mutasi_keluarga_repository_implementation.dart';
import 'package:jawara_pintar_mobile_version/features/mutasi-keluarga/domain/repositories/mutasi_keluarga_repository.dart';
import 'package:jawara_pintar_mobile_version/features/mutasi-keluarga/domain/usecases/create_mutasi_keluarga.dart';
import 'package:jawara_pintar_mobile_version/features/mutasi-keluarga/domain/usecases/get_all_mutasi_keluarga.dart';
import 'package:jawara_pintar_mobile_version/features/mutasi-keluarga/domain/usecases/get_form_data_options.dart';
import 'package:jawara_pintar_mobile_version/features/mutasi-keluarga/domain/usecases/get_mutasi_keluarga.dart';
import 'package:jawara_pintar_mobile_version/features/mutasi-keluarga/presentation/bloc/mutasi_keluarga_bloc.dart';

final myInjection = GetIt.instance;

Future<void> init() async {

  // myInjection.registerLazySingleton(() => );

  // datasource
  myInjection.registerLazySingleton<MutasiKeluargaDatasource>(() => MutasiKeluargaDatasourceImplementation());

  // repository
  myInjection.registerLazySingleton<MutasiKeluargaRepository>(() => MutasiKeluargaRepositoryImplementation(
    datasource: myInjection(),
  ));

  // Usecases
  myInjection.registerLazySingleton(() => GetAllMutasiKeluarga(myInjection()));
  myInjection.registerLazySingleton(() => GetMutasiKeluarga(myInjection()));
  myInjection.registerLazySingleton(() => CreateMutasiKeluarga(myInjection()));
  myInjection.registerLazySingleton(() => GetFormDataOptions(myInjection()));

  // bloc
  myInjection.registerFactory(() => MutasiKeluargaBloc(
    getAllMutasiKeluarga: myInjection(),
    getMutasiKeluarga: myInjection(),
    createMutasiKeluarga: myInjection(),
    getFormDataOptions: myInjection()
  ));

}