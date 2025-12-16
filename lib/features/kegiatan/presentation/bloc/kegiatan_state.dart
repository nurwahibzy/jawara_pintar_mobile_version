part of 'kegiatan_bloc.dart';

abstract class KegiatanState extends Equatable {
  const KegiatanState();

  @override
  List<Object?> get props => [];
}

class KegiatanInitial extends KegiatanState {}

class KegiatanLoading extends KegiatanState {}

class KegiatanListLoaded extends KegiatanState {
  final List<Kegiatan> kegiatanList;

  const KegiatanListLoaded(this.kegiatanList);

  @override
  List<Object> get props => [kegiatanList];
}

class KegiatanDetailLoaded extends KegiatanState {
  final Kegiatan kegiatan;

  const KegiatanDetailLoaded(this.kegiatan);

  @override
  List<Object> get props => [kegiatan];
}

class KegiatanActionSuccess extends KegiatanState {
  final String message;

  const KegiatanActionSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class KegiatanError extends KegiatanState {
  final String message;

  const KegiatanError(this.message);

  @override
  List<Object> get props => [message];
}

// ==================== TRANSAKSI STATES ====================

class TransaksiKegiatanLoaded extends KegiatanState {
  final List<TransaksiKegiatan> transaksiList;

  const TransaksiKegiatanLoaded(this.transaksiList);

  @override
  List<Object> get props => [transaksiList];
}

class TransaksiActionSuccess extends KegiatanState {
  final String message;

  const TransaksiActionSuccess(this.message);

  @override
  List<Object> get props => [message];
}
