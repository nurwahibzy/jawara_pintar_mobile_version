import 'package:flutter/material.dart';

class TambahPengguna extends StatefulWidget {
  const TambahPengguna({super.key});

  @override
  State<TambahPengguna> createState() => _TambahPenggunaPageState();
}

class _TambahPenggunaPageState extends State<TambahPengguna> {
  final namaController = TextEditingController();
  final nikController = TextEditingController();
  final teleponController = TextEditingController();
  final tempatLahirController = TextEditingController();

  String? nama;
  String? email;
  String? noHP;
  String? password;
  String? konfirmasiPassword;
  String? role;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 235, 235, 235),
      appBar: AppBar(
        title: const Text(
          "Tambah Pengguna",
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
              _buildTextField('Nama', 'Masukkan Nama'),
              const SizedBox(height: 14),
              _buildTextField('Email', 'Masukkan Email'),
              const SizedBox(height: 14),
              _buildTextField('No HP', 'Masukkan No HP'),
              const SizedBox(height: 14),
              _buildTextField('Password baru', 'Masukkan Password baru'),
              const SizedBox(height: 14),
              _buildTextField('Konfirmasi Password Baru', 'Masukkan Konfirmasi Password Baru'),
              const SizedBox(height: 14),
              _buildDropdown(
                label: "Role",
                value: role,
                items: [
                  "Admin",
                  "Ketua RW",
                  "Ketua RT",
                  "Sekretaris",
                  "Bendahara",
                  "Warga",
                ],
                onChanged: (val) => setState(() => role = val),
              ),
              const SizedBox(height: 14),

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
                        Navigator.pushNamed(context, '/daftar_pengguna');
                      },
                      child: const Text(
                        "Simpan",
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
    ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 6),
        TextField(
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
