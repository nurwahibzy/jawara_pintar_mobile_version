class PenerimaanWarga {
final int id;
final String namaPemohon;
final String nik;
final String noHp;
final String fotoKtpKk;
final Map<String, dynamic> dataLengkap;
final String status;
final String? alasanPenolakan;


PenerimaanWarga({
required this.id,
required this.namaPemohon,
required this.nik,
required this.noHp,
required this.fotoKtpKk,
required this.dataLengkap,
required this.status,
this.alasanPenolakan,
});
}