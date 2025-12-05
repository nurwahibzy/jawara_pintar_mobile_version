import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'cetak_laporan_event.dart';
part 'cetak_laporan_state.dart';

class CetakLaporanBloc extends Bloc<CetakLaporanEvent, CetakLaporanState> {
  CetakLaporanBloc() : super(CetakLaporanInitial()) {
    on<CetakLaporanEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
