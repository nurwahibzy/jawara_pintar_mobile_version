import 'package:flutter/material.dart';

class EditPesanWarga extends StatefulWidget {
  const EditPesanWarga({super.key, required this.pesan});
  final Map<String, dynamic> pesan;

  @override
  State<EditPesanWarga> createState() => _EditPesanWargaState();
}

class _EditPesanWargaState extends State<EditPesanWarga> {
  // 1. Deklarasikan semua controller dan state dropdown
  late TextEditingController _judulController;
  late TextEditingController _deskripsiController;
  late TextEditingController _statusController;


  @override
  void initState() {
    super.initState();

    _judulController = TextEditingController(
      text: widget.pesan['judul']?.toString() ?? '',
    );
    _deskripsiController = TextEditingController(
      text: widget.pesan['deskripsi']?.toString() ?? '',
    );
    _statusController = TextEditingController(
      text: widget.pesan['status']?.toString() ?? '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 235, 235, 235),
      appBar: AppBar(
        title: const Text(
          "Edit Pesan",
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
              // 4. Masukkan controller ke _buildTextField
              _buildTextField(
                'Judul',
                'Masukkan Judul',
                _judulController,
                readOnly: true
              ),
              const SizedBox(height: 14),
              _buildTextField(
                'Deskripsi Pesan',
                'Masukkan Deskripsi Pesan',
                _deskripsiController,
                readOnly: true
              ),
              const SizedBox(height: 14),

              _buildDropdown(
                label: 'Status',
                value: widget.pesan['status']?.toString(),
                items: ["Diterima", "Dipending", "Ditolak"],
                onChanged: (val) {
                  setState(() {
                    _statusController.text = val ?? '';
                  });
                },
                readOnly: false,
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
                        Navigator.pushNamed(context, '/daftar_pesan');
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
    TextEditingController controller, {
    bool isObscure = false,
    bool readOnly = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 6),
        TextField(
          controller: controller, // Pasang controller di sini
          obscureText: isObscure, // Gunakan parameter
          cursorColor: const Color.fromARGB(255, 45, 92, 21),
          decoration: InputDecoration(
            border: _border(),
            enabledBorder: _border(),
            focusedBorder: _focusBorder(),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 12,
            ),
          ),
          readOnly: readOnly,
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?)? onChanged, // <-- Tetap pakai '?'
    bool readOnly = false, // <-- TAMBAHKAN INI
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
            // Tambahkan ini agar terlihat abu-abu
            fillColor: readOnly ? Colors.grey[200] : Colors.transparent,
            filled: readOnly,
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
          // Gunakan logika readOnly di sini
          onChanged: readOnly ? null : onChanged,
        ),
      ],
    );
  }
}
