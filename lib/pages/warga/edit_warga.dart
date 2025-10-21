import 'package:flutter/material.dart';

class EditWarga extends StatefulWidget {
  final Map<String, dynamic> warga;

  const EditWarga({super.key, required this.warga});

  @override
  State<EditWarga> createState() => _EditWargaPageState();
}

class _EditWargaPageState extends State<EditWarga> {
  late TextEditingController namaController;
  late TextEditingController nikController;
  late TextEditingController teleponController;
  late TextEditingController tempatLahirController;
  DateTime? tanggalLahir;

  String? keluarga;
  String? jenisKelamin;
  String? agama;
  String? golonganDarah;
  String? peranKeluarga;
  String? pendidikan;
  String? pekerjaan;
  String? status;

  @override
  void initState() {
    super.initState();
    final warga = widget.warga;
    namaController = TextEditingController(text: warga['nama']);
    nikController = TextEditingController(text: warga['nik']);
    teleponController = TextEditingController(text: warga['telepon']);
    tempatLahirController = TextEditingController(text: warga['tempat_lahir']);
    tanggalLahir = DateTime.tryParse(warga['tanggal_lahir'] ?? '');
    keluarga = warga['keluarga'];
    jenisKelamin = warga['jenis_kelamin'];
    agama = warga['agama'];
    golonganDarah = warga['golongan_darah'];
    peranKeluarga = warga['peran_keluarga'];
    pendidikan = warga['pendidikan'];
    pekerjaan = warga['pekerjaan'];
    status = warga['status'];
  }

  Future<void> _pickTanggalLahir() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: tanggalLahir ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.green,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => tanggalLahir = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 235, 235, 235),
      appBar: AppBar(
        title: const Text(
          "Edit Data Warga",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 2,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDropdown(
                label: "Pilih Keluarga",
                value: keluarga,
                items: ["Keluarga A", "Keluarga B", "Keluarga C"],
                onChanged: (val) => setState(() => keluarga = val),
              ),
              const SizedBox(height: 14),
              _buildTextField("Nama", "Masukkan nama lengkap", namaController),
              const SizedBox(height: 14),
              _buildTextField(
                "NIK",
                "Masukkan NIK sesuai KTP",
                nikController,
                type: TextInputType.number,
              ),
              const SizedBox(height: 14),
              _buildTextField(
                "Nomor Telepon",
                "08xxxxxx",
                teleponController,
                type: TextInputType.phone,
              ),
              const SizedBox(height: 14),
              _buildTextField(
                "Tempat Lahir",
                "Masukkan tempat lahir",
                tempatLahirController,
              ),
              const SizedBox(height: 14),
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
                      border: _border(),
                      enabledBorder: _border(),
                      focusedBorder: _focusBorder(),
                      suffixIcon: const Icon(Icons.calendar_today),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 12,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              _buildDropdown(
                label: "Jenis Kelamin",
                value: jenisKelamin,
                items: ["Laki - Laki", "Perempuan"],
                onChanged: (val) => setState(() => jenisKelamin = val),
              ),
              const SizedBox(height: 14),
              _buildDropdown(
                label: "Agama",
                value: agama,
                items: [
                  "Islam",
                  "Kristen",
                  "Katholik",
                  "Hindu",
                  "Buddha",
                  "Konghucu",
                ],
                onChanged: (val) => setState(() => agama = val),
              ),
              const SizedBox(height: 14),
              _buildDropdown(
                label: "Golongan Darah",
                value: golonganDarah,
                items: ["A", "B", "AB", "O"],
                onChanged: (val) => setState(() => golonganDarah = val),
              ),
              const SizedBox(height: 14),
              _buildDropdown(
                label: "Peran Keluarga",
                value: peranKeluarga,
                items: ["Ayah", "Ibu", "Anak", "Lainnya"],
                onChanged: (val) => setState(() => peranKeluarga = val),
              ),
              const SizedBox(height: 14),
              _buildDropdown(
                label: "Pendidikan Terakhir",
                value: pendidikan,
                items: [
                  "Tidak Sekolah",
                  "SD",
                  "SMP",
                  "SMA",
                  "Diploma",
                  "Sarjana",
                  "Pascasarjana",
                  "Lainnya",
                ],
                onChanged: (val) => setState(() => pendidikan = val),
              ),
              const SizedBox(height: 14),
              _buildDropdown(
                label: "Pekerjaan",
                value: pekerjaan,
                items: [
                  "Tidak Bekerja",
                  "Pelajar/Mahasiswa",
                  "PNS",
                  "Wiraswasta",
                  "Buruh",
                  "BUMN",
                  "Lainnya",
                ],
                onChanged: (val) => setState(() => pekerjaan = val),
              ),
              const SizedBox(height: 14),
              _buildDropdown(
                label: "Status",
                value: status,
                items: ["Aktif", "Tidak Aktif"],
                onChanged: (val) => setState(() => status = val),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context, {
                          ...widget.warga,
                          'nama': namaController.text,
                          'nik': nikController.text,
                          'telepon': teleponController.text,
                          'tempat_lahir': tempatLahirController.text,
                          'tanggal_lahir': tanggalLahir != null
                              ? tanggalLahir!.toIso8601String()
                              : null,
                          'keluarga': keluarga,
                          'jenis_kelamin': jenisKelamin,
                          'agama': agama,
                          'golongan_darah': golonganDarah,
                          'peran_keluarga': peranKeluarga,
                          'pendidikan': pendidikan,
                          'pekerjaan': pekerjaan,
                          'status': status,
                        });
                      },
                      child: const Text(
                        "Simpan Perubahan",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Batal",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
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
    );
  }

  OutlineInputBorder _border() => const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
    borderSide: BorderSide(color: Colors.grey),
  );

  OutlineInputBorder _focusBorder() => const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
    borderSide: BorderSide(color: Color.fromARGB(255, 45, 92, 21), width: 2),
  );

  Widget _buildTextField(
    String label,
    String hint,
    TextEditingController controller, {
    TextInputType? type,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: type,
          cursorColor: const Color.fromARGB(255, 45, 92, 21),
          decoration: InputDecoration(
            hintText: hint,
            border: _border(),
            enabledBorder: _border(),
            focusedBorder: _focusBorder(),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            border: _border(),
            enabledBorder: _border(),
            focusedBorder: _focusBorder(),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 12,
            ),
          ),
          dropdownColor: const Color.fromARGB(255, 209, 220, 203),
          value: value,
          hint: Text("-- Pilih $label --"),
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
