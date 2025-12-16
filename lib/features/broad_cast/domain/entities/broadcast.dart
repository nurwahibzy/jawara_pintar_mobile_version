class Broadcast {
  final int id;
  final String judul;
  final String isiPesan;
  final DateTime tanggalPublikasi;
  final String? lampiranGambar;
  final String? lampiranDokumen;
  final int createdBy;

  // Getter agar kompatibel dengan kode lama
  String get title => judul;
  String get content => isiPesan;

  Broadcast({
    required this.id,
    required this.judul,
    required this.isiPesan,
    required this.tanggalPublikasi,
    this.lampiranGambar,
    this.lampiranDokumen,
    required this.createdBy,
  });
}
