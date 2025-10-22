import 'package:flutter/material.dart';

class DaftarPengeluaran extends StatefulWidget {
  const DaftarPengeluaran({super.key});

  @override
  State<DaftarPengeluaran> createState() => _DaftarPengeluaranState();
}

class _DaftarPengeluaranState extends State<DaftarPengeluaran> {
  List<Map<String, dynamic>> pengeluaranList = [
    {
      'nama': 'Beli Peralatan Kebersihan',
      'tanggal': '10/10/2025',
      'kategori': 'Kebersihan',
      'nominal': '150000',
      'tanggal_verifikasi': '12/10/2025 14:30',
      'verifikator': 'Admin Jawara',
    },
    {
      'nama': 'Bayar Tukang',
      'tanggal': '15/10/2025',
      'kategori': 'Perawatan',
      'nominal': '500000',
      'tanggal_verifikasi': '16/10/2025 10:15',
      'verifikator': 'Admin Jawara',
    },
  ];

  // --- Filter State ---
  bool _showFilter = false;
  final TextEditingController _searchController = TextEditingController();
  String? _filterKategori;
  DateTime? _filterDari;
  DateTime? _filterSampai;

  List<Map<String, dynamic>> get filteredPengeluaran {
    return pengeluaranList.where((item) {
      final searchMatch = item['nama'].toLowerCase().contains(
        _searchController.text.toLowerCase(),
      );
      final kategoriMatch =
          _filterKategori == null || _filterKategori == '-- Pilih Kategori --'
          ? true
          : item['kategori'] == _filterKategori;
      final dariMatch = _filterDari == null
          ? true
          : DateTime.tryParse(
              item['tanggal'].split('/').reversed.join('-'),
            )!.isAfter(_filterDari!.subtract(const Duration(days: 1)));
      final sampaiMatch = _filterSampai == null
          ? true
          : DateTime.tryParse(
              item['tanggal'].split('/').reversed.join('-'),
            )!.isBefore(_filterSampai!.add(const Duration(days: 1)));
      return searchMatch && kategoriMatch && dariMatch && sampaiMatch;
    }).toList();
  }

  Future<void> _pickTanggalDari() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _filterDari ?? DateTime.now(),
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
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _filterDari = picked);
  }

  Future<void> _pickTanggalSampai() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _filterSampai ?? DateTime.now(),
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
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _filterSampai = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daftar Pengeluaran',
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
          // --- Filter Panel ---
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
                      TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Cari nama...',
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.grey,
                              width: 0.8,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.green,
                              width: 1.2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: _filterKategori ?? '-- Pilih Kategori --',
                        dropdownColor: Colors.white,
                        iconEnabledColor: Colors.green,
                        decoration: InputDecoration(
                          labelText: 'Kategori',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        items:
                            [
                                  '-- Pilih Kategori --',
                                  'Kebersihan',
                                  'Perawatan',
                                  'Lainnya',
                                ]
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ),
                                )
                                .toList(),
                        onChanged: (val) =>
                            setState(() => _filterKategori = val),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              readOnly: true,
                              decoration: InputDecoration(
                                labelText: 'Dari Tanggal',
                                hintText: _filterDari == null
                                    ? '--/--/----'
                                    : '${_filterDari!.day}/${_filterDari!.month}/${_filterDari!.year}',
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onTap: _pickTanggalDari,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              readOnly: true,
                              decoration: InputDecoration(
                                labelText: 'Sampai Tanggal',
                                hintText: _filterSampai == null
                                    ? '--/--/----'
                                    : '${_filterSampai!.day}/${_filterSampai!.month}/${_filterSampai!.year}',
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onTap: _pickTanggalSampai,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton(
                            onPressed: () {
                              setState(() {
                                _searchController.clear();
                                _filterKategori = '-- Pilih Kategori --';
                                _filterDari = null;
                                _filterSampai = null;
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
                              setState(() {}); // Terapkan filter
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

          // --- List Pengeluaran ---
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: filteredPengeluaran.length,
              itemBuilder: (context, index) {
                final item = filteredPengeluaran[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text(item['nama']),
                    subtitle: Text(
                      "Tanggal: ${item['tanggal']}\nKategori: ${item['kategori']}",
                    ),
                    trailing: Text(
                      "Rp ${item['nominal']}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailPengeluaran(pengeluaran: item),
                        ),
                      );
                      if (result == 'hapus') {
                        setState(() {
                          pengeluaranList.removeAt(index);
                        });
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Pengeluaran'),
        onPressed: () {
          Navigator.pushNamed(context, '/tambah_pengeluaran');
        },
      ),
    );
  }
}

class DetailPengeluaran extends StatelessWidget {
  final Map<String, dynamic> pengeluaran;

  const DetailPengeluaran({super.key, required this.pengeluaran});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pengeluaran'),
        backgroundColor: Colors.green,
        centerTitle: true,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                Text(
                  pengeluaran['nama'] ?? '-',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Divider(),
                _buildDetailItem('Tanggal', pengeluaran['tanggal']),
                _buildDetailItem('Kategori', pengeluaran['kategori']),
                _buildDetailItem('Nominal', pengeluaran['nominal']),
                _buildDetailItem(
                  'Tanggal Terverifikasi',
                  pengeluaran['tanggal_verifikasi'],
                ),
                _buildDetailItem('Verifikator', pengeluaran['verifikator']),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 155,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          const Text(": "),
          Expanded(child: Text(value != null ? value.toString() : '-')),
        ],
      ),
    );
  }
}