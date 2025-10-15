import 'package:flutter/material.dart';

class TambahWarga extends StatefulWidget {
  const TambahWarga({super.key});

  @override
  State<TambahWarga> createState() => _TambahWargaPageState();
}

class _TambahWargaPageState extends State<TambahWarga> {
  // Controller
  final namaController = TextEditingController();
  final nikController = TextEditingController();
  final teleponController = TextEditingController();
  final tempatLahirController = TextEditingController();

  // Variabel field form
  DateTime? tanggalLahir;
  String? keluarga;
  String? jenisKelamin;
  String? agama;
  String? golonganDarah;
  String? peranKeluarga;
  String? pendidikan;
  String? pekerjaan;
  String? status;

  Future<void> _pickTanggalLahir() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: tanggalLahir ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: const Color.fromARGB(255, 45, 92, 21),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color.fromARGB(255, 45, 92, 21),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => tanggalLahir = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color.fromARGB(255, 220, 220, 220),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // === JUDUL ===
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: const Text(
                        "Tambah Warga",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 45, 92, 21),
                        ),
                      ),
                    ),

                    // === PILIH KELUARGA ===
                    const Text("Pilih Keluarga"),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 45, 92, 21),
                            width: 2,
                          ),
                        ),
                        hintText: "-- Pilih Keluarga --",
                        suffixIcon: keluarga != null
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () =>
                                    setState(() => keluarga = null),
                              )
                            : null,
                      ),
                      dropdownColor: const Color.fromARGB(255, 209, 220, 203),
                      value: keluarga,
                      items: ["Keluarga A", "Keluarga B", "Keluarga C"]
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                      onChanged: (val) => setState(() => keluarga = val),
                    ),
                    const SizedBox(height: 16),

                    // === NAMA ===
                    const Text("Nama"),
                    const SizedBox(height: 6),
                    TextField(
                      cursorColor: Color.fromARGB(255, 45, 92, 21),
                      controller: namaController,
                      decoration: const InputDecoration(
                        hintText: "Masukkan nama lengkap",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 45, 92, 21),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // === NIK ===
                    const Text("NIK"),
                    const SizedBox(height: 6),
                    TextField(
                      cursorColor: Color.fromARGB(255, 45, 92, 21),
                      controller: nikController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: "Masukkan NIK sesuai KTP",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 45, 92, 21),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // === NOMOR TELEPON ===
                    const Text("Nomor Telepon"),
                    const SizedBox(height: 6),
                    TextField(
                      cursorColor: Color.fromARGB(255, 45, 92, 21),
                      controller: teleponController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        hintText: "08xxxxxx",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 45, 92, 21),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // === TEMPAT LAHIR ===
                    const Text("Tempat Lahir"),
                    const SizedBox(height: 6),
                    TextField(
                      cursorColor: Color.fromARGB(255, 45, 92, 21),
                      controller: tempatLahirController,
                      decoration: const InputDecoration(
                        hintText: "Masukkan tempat lahir",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 45, 92, 21),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // === TANGGAL LAHIR ===
                    const Text("Tanggal Lahir"),
                    const SizedBox(height: 6),
                    GestureDetector(
                      onTap: _pickTanggalLahir,
                      child: AbsorbPointer(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: tanggalLahir == null
                                ? "-- Pilih Tanggal --"
                                : "${tanggalLahir!.day}/${tanggalLahir!.month}/${tanggalLahir!.year}",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 45, 92, 21),
                                width: 2,
                              ),
                            ),
                            suffixIcon: const Icon(Icons.calendar_today),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // jenis kelamin
                    const Text("Jenis Kelamin"),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 45, 92, 21),
                            width: 2,
                          ),
                        ),
                        hintText: "-- Pilih Jenis Kelamin --",
                        suffixIcon: jenisKelamin != null
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () =>
                                    setState(() => jenisKelamin = null),
                              )
                            : null,
                      ),
                      dropdownColor: const Color.fromARGB(255, 209, 220, 203),
                      value: jenisKelamin,
                      items: ["Laki - Laki", "Perempuan"]
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                      onChanged: (val) => setState(() => jenisKelamin = val),
                    ),
                    const SizedBox(height: 16),

                    // agama
                    const Text("Agama"),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 45, 92, 21),
                            width: 2,
                          ),
                        ),
                        hintText: "-- Pilih Agama --",
                        suffixIcon: agama != null
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () => setState(() => agama = null),
                              )
                            : null,
                      ),
                      dropdownColor: const Color.fromARGB(255, 209, 220, 203),
                      value: agama,
                      items:
                          [ "Islam", "Kristen", "Katholik", "Hindu", "Buddha", "Konghucu",]
                              .map(
                                (e) =>
                                    DropdownMenuItem(value: e, child: Text(e)),
                              )
                              .toList(),
                      onChanged: (val) => setState(() => agama = val),
                    ),
                    const SizedBox(height: 16),

                    // golongan darah
                    const Text("Golongan Darah"),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 45, 92, 21),
                            width: 2,
                          ),
                        ),
                        hintText: "-- Pilih Golongan Darah --",
                        suffixIcon: golonganDarah != null
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () =>
                                    setState(() => golonganDarah = null),
                              )
                            : null,
                      ),
                      dropdownColor: const Color.fromARGB(255, 209, 220, 203),
                      value: golonganDarah,
                      items: ["A", "B", "AB", "O"]
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                      onChanged: (val) => setState(() => golonganDarah = val),
                    ),
                    const SizedBox(height: 16),

                    // peran keluarga
                    const Text("Peran Keluarga"),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 45, 92, 21),
                            width: 2,
                          ),
                        ),
                        hintText: "-- Pilih Peran Keluarga --",
                        suffixIcon: peranKeluarga != null
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () =>
                                    setState(() => peranKeluarga = null),
                              )
                            : null,
                      ),
                      dropdownColor: const Color.fromARGB(255, 209, 220, 203),
                      value: peranKeluarga,
                      items: ["Ayah", "Ibu", "Anak", "Lainnya"]
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                      onChanged: (val) => setState(() => peranKeluarga = val),
                    ),
                    const SizedBox(height: 16),

                    // pendidikan terakhir
                    const Text("Pendidikan Terakhir"),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 45, 92, 21),
                            width: 2,
                          ),
                        ),
                        hintText: "-- Pilih Pendidikan Terakhir --",
                        suffixIcon: pendidikan != null
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () =>
                                    setState(() => pendidikan = null),
                              )
                            : null,
                      ),
                      dropdownColor: const Color.fromARGB(255, 209, 220, 203),
                      value: pendidikan,
                      items:
                          [ "tidak sekolah", "SD", "SMP", "SMA", "Diploma","Sarjana","Pascasarjana","Lainnya",]
                              .map(
                                (e) =>
                                    DropdownMenuItem(value: e, child: Text(e)),
                              )
                              .toList(),
                      onChanged: (val) => setState(() => pendidikan = val),
                    ),
                    const SizedBox(height: 16),

                    // pekerjaan
                    const Text("Pilih Pekerjaan"),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 45, 92, 21),
                            width: 2,
                          ),
                        ),
                        hintText: "-- Pilih Pekerjaan --",
                        suffixIcon: pekerjaan != null
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () =>
                                    setState(() => pekerjaan = null),
                              )
                            : null,
                      ),
                      dropdownColor: const Color.fromARGB(255, 209, 220, 203),
                      value: pekerjaan,
                      items:
                          ["Tidak Bekerja","Pelajar/Mahasiswa","PNS","Wiraswasta","Buruh","BUMN","Lainnya",]
                              .map(
                                (e) =>
                                    DropdownMenuItem(value: e, child: Text(e)),
                              )
                              .toList(),
                      onChanged: (val) => setState(() => pekerjaan = val),
                    ),
                    const SizedBox(height: 16),

                    // status
                    const Text("Status"),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 45, 92, 21),
                            width: 2,
                          ),
                        ),
                        hintText: "-- Pilih Status --",
                        suffixIcon: status != null
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () => setState(() => status = null),
                              )
                            : null,
                      ),
                      dropdownColor: const Color.fromARGB(255, 209, 220, 203),
                      value: status,
                      items: ["Aktif", "Tidak Aktif"]
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                      onChanged: (val) => setState(() => status = val),
                    ),
                    const SizedBox(height: 16),

                    // === TOMBOL SUBMIT DAN RESET ===
                    Row(
                      children: [
                        // Tombol Submit
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255,45,92,21,),
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              // Navigasi ke halaman daftar warga
                              Navigator.pushNamed(context, '/daftarWarga');
                            },
                            child: const Text(
                              "Submit",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),

                        // Tombol Reset
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                // Reset semua field
                                keluarga = null;
                                namaController.clear();
                                nikController.clear();
                                teleponController.clear();
                                tempatLahirController.clear();
                                tanggalLahir = null;
                                jenisKelamin = null;
                                agama = null;
                                golonganDarah = null;
                                peranKeluarga = null;
                                pendidikan = null;
                                pekerjaan = null;
                                status = null;
                              });
                            },
                            child: const Text(
                              "Reset",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}