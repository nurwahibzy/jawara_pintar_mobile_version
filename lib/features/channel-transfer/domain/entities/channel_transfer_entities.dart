import 'package:equatable/equatable.dart';

enum ChannelType { Bank, EWallet, QRIS }

class TransferChannel extends Equatable {
  final int? id;
  final String namaChannel;
  final ChannelType tipe;
  final String? nomorRekening;
  final String? namaPemilik;
  final String? qrUrl;
  final String? thumbnailUrl;
  final String? catatan;
  final int? createdBy;
  final DateTime? createdAt;

  const TransferChannel({
    this.id,
    required this.namaChannel,
    required this.tipe,
    this.nomorRekening,
    this.namaPemilik,
    this.qrUrl,
    this.thumbnailUrl,
    this.catatan,
    this.createdBy,
    this.createdAt,
  });

  TransferChannel copyWith({
    int? id,
    String? namaChannel,
    ChannelType? tipe,
    String? nomorRekening,
    String? namaPemilik,
    String? qrUrl,
    String? thumbnailUrl,
    String? catatan,
    int? createdBy,
    DateTime? createdAt,
  }) {
    return TransferChannel(
      id: id ?? this.id,
      namaChannel: namaChannel ?? this.namaChannel,
      tipe: tipe ?? this.tipe,
      nomorRekening: nomorRekening ?? this.nomorRekening,
      namaPemilik: namaPemilik ?? this.namaPemilik,
      qrUrl: qrUrl ?? this.qrUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      catatan: catatan ?? this.catatan,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    namaChannel,
    tipe,
    nomorRekening,
    namaPemilik,
    qrUrl,
    thumbnailUrl,
    catatan,
    createdBy,
    createdAt,
  ];
}