part of 'pemasukan_bloc.dart';

abstract class PemasukanEvent extends Equatable {
  const PemasukanEvent();

  @override
  List<Object?> get props => [];
}

class GetPemasukanListEvent extends PemasukanEvent {
  final String? kategoriFilter;

  const GetPemasukanListEvent({this.kategoriFilter});

  @override
  List<Object?> get props => [kategoriFilter];
}

class GetPemasukanDetailEvent extends PemasukanEvent {
  final int id;

  const GetPemasukanDetailEvent(this.id);

  @override
  List<Object> get props => [id];
}

class CreatePemasukanEvent extends PemasukanEvent {
  final String judul;
  final int kategoriTransaksiId;
  final double nominal;
  final String tanggalTransaksi;
  final String? buktiFoto;
  final String keterangan;
  final File? buktiFile;

  const CreatePemasukanEvent({
    required this.judul,
    required this.kategoriTransaksiId,
    required this.nominal,
    required this.tanggalTransaksi,
    this.buktiFoto,
    required this.keterangan,
    this.buktiFile,
  });

  @override
  List<Object?> get props => [
    judul,
    kategoriTransaksiId,
    nominal,
    tanggalTransaksi,
    buktiFoto,
    keterangan,
    buktiFile,
  ];
}

class UpdatePemasukanEvent extends PemasukanEvent {
  final int id;
  final String judul;
  final int kategoriTransaksiId;
  final double nominal;
  final String tanggalTransaksi;
  final String? buktiFoto;
  final String keterangan;
  final File? buktiFile;
  final String? oldBuktiUrl;

  const UpdatePemasukanEvent({
    required this.id,
    required this.judul,
    required this.kategoriTransaksiId,
    required this.nominal,
    required this.tanggalTransaksi,
    this.buktiFoto,
    required this.keterangan,
    this.buktiFile,
    this.oldBuktiUrl,
  });

  @override
  List<Object?> get props => [
    id,
    judul,
    kategoriTransaksiId,
    nominal,
    tanggalTransaksi,
    buktiFoto,
    keterangan,
    buktiFile,
    oldBuktiUrl,
  ];
}

class DeletePemasukanEvent extends PemasukanEvent {
  final int id;

  const DeletePemasukanEvent(this.id);

  @override
  List<Object> get props => [id];
}
