part of 'kegiatan_bloc.dart';

abstract class KegiatanEvent extends Equatable {
  const KegiatanEvent();

  @override
  List<Object?> get props => [];
}

class GetKegiatanListEvent extends KegiatanEvent {}

class GetKegiatanDetailEvent extends KegiatanEvent {
  final int id;

  const GetKegiatanDetailEvent(this.id);

  @override
  List<Object> get props => [id];
}

class CreateKegiatanEvent extends KegiatanEvent {
  final Kegiatan kegiatan;

  const CreateKegiatanEvent(this.kegiatan);

  @override
  List<Object> get props => [kegiatan];
}

class UpdateKegiatanEvent extends KegiatanEvent {
  final Kegiatan kegiatan;

  const UpdateKegiatanEvent(this.kegiatan);

  @override
  List<Object> get props => [kegiatan];
}

// ==================== TRANSAKSI EVENTS ====================

class GetTransaksiKegiatanEvent extends KegiatanEvent {
  final int kegiatanId;

  const GetTransaksiKegiatanEvent(this.kegiatanId);

  @override
  List<Object> get props => [kegiatanId];
}

class CreateTransaksiKegiatanEvent extends KegiatanEvent {
  final TransaksiKegiatan transaksi;

  const CreateTransaksiKegiatanEvent(this.transaksi);

  @override
  List<Object> get props => [transaksi];
}

class DeleteTransaksiKegiatanEvent extends KegiatanEvent {
  final int transaksiId;
  final int kegiatanId;

  const DeleteTransaksiKegiatanEvent(this.transaksiId, this.kegiatanId);

  @override
  List<Object> get props => [transaksiId, kegiatanId];
}
