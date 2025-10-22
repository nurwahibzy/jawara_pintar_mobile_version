import 'package:flutter/material.dart';

class DaftarLogAktivitas extends StatefulWidget {
  const DaftarLogAktivitas({super.key});

  @override
  State<DaftarLogAktivitas> createState() => _DaftarLogAktivitasState();
}

class _DaftarLogAktivitasState extends State<DaftarLogAktivitas> {
  bool _showFilter = false;
  final TextEditingController _searchDeskripsi = TextEditingController();
  final TextEditingController _namaPelaku = TextEditingController();
  final TextEditingController _dariTanggal = TextEditingController();
  final TextEditingController _sampaiTanggal = TextEditingController();

  // Data dummy
  List<Map<String, String>> logList = [
    {
      'deskripsi': 'Menambah data warga',
      'pelaku': 'Fafa',
      'tanggal': '20/10/2025 10:30',
    },
    {
      'deskripsi': 'Menghapus pengeluaran',
      'pelaku': 'Budi',
      'tanggal': '21/10/2025 14:20',
    },
    {
      'deskripsi': 'Mengedit tagihan',
      'pelaku': 'Fafa',
      'tanggal': '22/10/2025 09:10',
    },
  ];

  // Fungsi untuk memilih tanggal (tanpa intl)
  Future<void> _pickDate(TextEditingController controller) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.green,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Colors.green),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        controller.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daftar Log Aktivitas',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              _showFilter ? Icons.close : Icons.filter_alt,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _showFilter = !_showFilter;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            crossFadeState: _showFilter
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Filter Aktivitas",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _searchDeskripsi,
                        decoration: InputDecoration(
                          labelText: "Deskripsi",
                          hintText: "Cari deskripsi...",
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _namaPelaku,
                        decoration: InputDecoration(
                          labelText: "Nama Pelaku",
                          hintText: "Contoh: Fafa",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () => _pickDate(_dariTanggal),
                        child: AbsorbPointer(
                          child: TextField(
                            controller: _dariTanggal,
                            decoration: InputDecoration(
                              labelText: "Dari Tanggal",
                              hintText: "--/--/----",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () => _pickDate(_sampaiTanggal),
                        child: AbsorbPointer(
                          child: TextField(
                            controller: _sampaiTanggal,
                            decoration: InputDecoration(
                              labelText: "Sampai Tanggal",
                              hintText: "--/--/----",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton(
                            onPressed: () {
                              setState(() {
                                _searchDeskripsi.clear();
                                _namaPelaku.clear();
                                _dariTanggal.clear();
                                _sampaiTanggal.clear();
                              });
                            },
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.grey[200],
                              foregroundColor: Colors.black,
                            ),
                            child: const Text("Reset Filter"),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {
                              // Belum pakai backend, hanya simulasi apply filter
                              setState(() {});
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text("Terapkan"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            secondChild: const SizedBox.shrink(),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: logList.length,
              itemBuilder: (context, index) {
                final item = logList[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 2,
                  child: ListTile(
                    title: Text(
                      item['deskripsi'] ?? '-',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      "Pelaku: ${item['pelaku']}\nTanggal: ${item['tanggal']}",
                    ),
                    leading: const Icon(Icons.history, color: Colors.green),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}