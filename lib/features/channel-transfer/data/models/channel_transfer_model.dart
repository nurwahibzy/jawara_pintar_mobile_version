import '../../domain/entities/channel_transfer_entities.dart';

class TransferChannelModel extends TransferChannel {
  const TransferChannelModel({
    super.id,
    required super.namaChannel,
    required super.tipe,
    super.nomorRekening,
    super.namaPemilik,
    super.qrUrl,
    super.thumbnailUrl,
    super.catatan,
    super.createdBy,
    super.createdAt,
  });

  /// Convert Map ke Model
  factory TransferChannelModel.fromMap(Map<String, dynamic> map) {
    return TransferChannelModel(
      id: map['id'],
      namaChannel: map['nama_channel'],
      tipe: _parseChannelType(map['tipe']),
      nomorRekening: map['nomor_rekening'],
      namaPemilik: map['nama_pemilik'],
      qrUrl: map['qr_url'],
      thumbnailUrl: map['thumbnail_url'],
      catatan: map['catatan'],
      createdBy: map['created_by'], 
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  /// Convert JSON ke Model
  factory TransferChannelModel.fromJson(Map<String, dynamic> json) {
    return TransferChannelModel.fromMap(json);
  }

  /// Convert Model ke Map
 Map<String, dynamic> toMap({bool forUpdate = false}) {
    final map = {
      'nama_channel': namaChannel,
      'tipe': tipe.label,
      'nomor_rekening': nomorRekening,
      'nama_pemilik': namaPemilik,
      'qr_url': qrUrl,
      'thumbnail_url': thumbnailUrl,
      'catatan': catatan,
      'created_by': createdBy, 
      'created_at': createdAt?.toIso8601String(),
    };

    if (forUpdate && id != null) {
      map['id'] = id; 
    }

    return map;
  }

  /// Convert Model -> Entity
  TransferChannel toEntity() {
    return TransferChannel(
      id: id,
      namaChannel: namaChannel,
      tipe: tipe,
      nomorRekening: nomorRekening,
      namaPemilik: namaPemilik,
      qrUrl: qrUrl,
      thumbnailUrl: thumbnailUrl,
      catatan: catatan,
      createdBy: createdBy,
      createdAt: createdAt,
    );
  }

  /// Convert Entity -> Model
  factory TransferChannelModel.fromEntity(TransferChannel entity) {
    return TransferChannelModel(
      id: entity.id,
      namaChannel: entity.namaChannel,
      tipe: entity.tipe,
      nomorRekening: entity.nomorRekening,
      namaPemilik: entity.namaPemilik,
      qrUrl: entity.qrUrl,
      thumbnailUrl: entity.thumbnailUrl,
      catatan: entity.catatan,
      createdBy: entity.createdBy,
      createdAt: entity.createdAt,
    );
  }

  @override
  TransferChannelModel copyWith({
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
    return TransferChannelModel(
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

static ChannelType _parseChannelType(String value) {
  final normalized = value.replaceAll('-', '').toLowerCase();

  switch (normalized) {
    case 'bank':
      return ChannelType.Bank;
    case 'ewallet':
      return ChannelType.EWallet;
    case 'qris':
      return ChannelType.QRIS;
    default:
      throw Exception('Unknown channel type: $value');
  }
}
}

extension ChannelTypeLabel on ChannelType {
  String get label {
    switch (this) {
      case ChannelType.Bank:
        return "Bank";
      case ChannelType.EWallet:
        return "E-Wallet"; 
      case ChannelType.QRIS:
        return "QRIS";
    }
  }
}
