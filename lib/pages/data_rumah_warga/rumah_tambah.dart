import 'package:flutter/material.dart';

class TambahRumah extends StatefulWidget {
  const TambahRumah({super.key});

  @override
  State<TambahRumah> createState() => _TambahRumahState();
}

class _TambahRumahState extends State<TambahRumah> {
  final TextEditingController _alamatController = TextEditingController();
  String? _selectedStatus;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: const ColorScheme.light(
          primary: Color.fromARGB(255, 45, 92, 21),
          secondary: Color.fromARGB(255, 45, 92, 21),
          surface: Colors.white,
        ),
      ),
    child:  Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Tambah Rumah Baru',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Form Input Rumah',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 30),

                // Alamat Rumah
                const Text(
                  'Alamat Rumah',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _alamatController,
                  cursorColor: Colors.green,
                  decoration: const InputDecoration(
                    hintText: 'Contoh: Jl. Merpati No. 5',
                    filled: true,
                    fillColor: Color.fromARGB(255, 235, 241, 232),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 0.8),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.green,
                        width: 1.2,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Status Rumah
                const Text(
                  'Status Rumah',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),

                Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: const ColorScheme.light(
                      primary: Colors.green,
                      surface: Color.fromARGB(255, 235, 241, 232),
                      onSurface: Colors.black,
                    ),
                  ),
                  child: DropdownButtonFormField<String>(
                    dropdownColor: Color.fromARGB(255, 235, 241, 232),
                    iconEnabledColor: Colors.green,
                    value: _selectedStatus,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color.fromARGB(255, 235, 241, 232),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                    hint: const Text('Pilih status'),
                    items: const [
                      DropdownMenuItem(
                        value: 'Ditempati',
                        child: Text('Ditempati'),
                      ),
                      DropdownMenuItem(value: 'Kosong', child: Text('Kosong')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedStatus = value;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 30),

                // Tombol aksi
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Tombol Reset
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _alamatController.clear();
                          _selectedStatus = null;
                        });
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reset'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[400],
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Tombol Simpan
                    ElevatedButton.icon(
                      onPressed: () {
                        if (_alamatController.text.isEmpty ||
                            _selectedStatus == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Mohon isi alamat dan pilih status rumah!',
                              ),
                            ),
                          );
                          return;
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Data rumah berhasil disimpan'),
                          ),
                        );
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.save),
                      label: const Text('Simpan'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
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
    )
    );
  }
}