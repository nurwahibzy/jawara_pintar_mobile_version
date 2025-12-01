class PenerimaanWarga {
  final int id;
  final String nama;
  final String nik;
  final String email;
  final String jenisKelamin;
  final String? fotoIdentitas;

  const PenerimaanWarga({
    required this.id,
    required this.nama,
    required this.nik,
    required this.email,
    required this.jenisKelamin,
    this.fotoIdentitas,
  });
}
