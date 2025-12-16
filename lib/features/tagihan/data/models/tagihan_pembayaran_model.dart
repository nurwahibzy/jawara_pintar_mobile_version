import '../../domain/entities/tagihan_pembayaran.dart';

class TagihanPembayaranModel extends TagihanPembayaran {
  const TagihanPembayaranModel({
    required super.id,
    required super.tagihanId,
    required super.metode,
    required super.bukti,
    required super.tanggalBayar,
    required super.statusVerifikasi,
    super.catatanAdmin,
    super.verifikatorId,
    required super.createdAt,
    super.kodeTagihan,
    super.keluargaId,
    super.masterIuranId,
    super.periode,
    super.nominal,
    super.statusTagihan,
    super.namaIuran,
    super.riwayatPembayaranId,
    super.metodePembayaran,
    super.buktiBayar,
    super.tanggalBayarRiwayat,
    super.statusVerifikasiRiwayat,
  });

  factory TagihanPembayaranModel.fromJson(Map<String, dynamic> json) {
    // Jika data dari tabel pembayaran_tagihan (struktur lama)
    if (json.containsKey('tagihan_id')) {
      final tagihan = json['tagihan'] as Map<String, dynamic>?;
      final masterIuran = tagihan?['master_iuran'] as Map<String, dynamic>?;

      return TagihanPembayaranModel(
        id: json['id'] as int,
        tagihanId: json['tagihan_id'] as int,
        metode: json['metode_pembayaran'] as String? ?? '',
        bukti: json['bukti_bayar'] as String? ?? '',
        tanggalBayar: DateTime.parse(json['tanggal_bayar'] as String),
        statusVerifikasi: json['status_verifikasi'] as String? ?? 'Pending',
        catatanAdmin: json['catatan_admin'] as String?,
        verifikatorId: json['verifikator_id'] as int?,
        createdAt: DateTime.parse(json['created_at'] as String),
        kodeTagihan: tagihan?['kode_tagihan'] as String?,
        keluargaId: tagihan?['keluarga_id'] as int?,
        masterIuranId: tagihan?['master_iuran_id'] as int?,
        periode: tagihan?['periode'] as String?,
        nominal: (tagihan?['nominal'] as num?)?.toDouble(),
        statusTagihan: tagihan?['status_tagihan'] as String?,
        namaIuran: masterIuran?['nama_iuran'] as String?,
      );
    }

    // Jika data langsung dari tabel tagihan (struktur baru)
    final masterIuran = json['master_iuran'] as Map<String, dynamic>?;
    final pembayaranTagihan = json['pembayaran_tagihan'] as List?;
    final riwayat = pembayaranTagihan != null && pembayaranTagihan.isNotEmpty
        ? pembayaranTagihan[0] as Map<String, dynamic>
        : null;

    return TagihanPembayaranModel(
      id: json['id'] as int,
      tagihanId: json['id'] as int,
      metode: '',
      bukti: '',
      tanggalBayar: DateTime.parse(json['created_at'] as String),
      statusVerifikasi: json['status_tagihan'] as String? ?? 'Belum Lunas',
      catatanAdmin: null,
      verifikatorId: null,
      createdAt: DateTime.parse(json['created_at'] as String),
      kodeTagihan: json['kode_tagihan'] as String?,
      keluargaId: json['keluarga_id'] as int?,
      masterIuranId: json['master_iuran_id'] as int?,
      periode: json['periode'] as String?,
      nominal: (json['nominal'] as num?)?.toDouble(),
      statusTagihan: json['status_tagihan'] as String?,
      namaIuran: masterIuran?['nama_iuran'] as String?,
      // Riwayat pembayaran (jika ada)
      riwayatPembayaranId: riwayat?['id'] as int?,
      metodePembayaran: riwayat?['metode_pembayaran'] as String?,
      buktiBayar: riwayat?['bukti_bayar'] as String?,
      tanggalBayarRiwayat: riwayat?['tanggal_bayar'] != null
          ? DateTime.parse(riwayat!['tanggal_bayar'] as String)
          : null,
      statusVerifikasiRiwayat: riwayat?['status_verifikasi'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tagihan_id': tagihanId,
      'metode_pembayaran': metode,
      'bukti_bayar': bukti,
      'tanggal_bayar': tanggalBayar.toIso8601String(),
      'status_verifikasi': statusVerifikasi,
      'catatan_admin': catatanAdmin,
      'verifikator_id': verifikatorId,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
