class Warga {
final int no;
final String nama;
final String nik;
final String email;
final String jenisKelamin;
final String? fotoIdentitas; // nullable
final String statusRegistrasi;


Warga({
required this.no,
required this.nama,
required this.nik,
required this.email,
required this.jenisKelamin,
required this.fotoIdentitas,
required this.statusRegistrasi,
});


String displayData() {
return "No: $no | Nama: $nama | NIK: $nik | Email: $email | JK: $jenisKelamin | Foto: ${fotoIdentitas ?? '-'} | Status: $statusRegistrasi";
}
}