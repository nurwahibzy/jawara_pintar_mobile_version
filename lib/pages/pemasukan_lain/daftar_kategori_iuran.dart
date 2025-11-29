import 'package:flutter/material.dart';
import 'tambah_kategori_iuran.dart';
import 'detail_kategori_iuran.dart';
import 'edit_kategori_iuran.dart';

class DaftarKategoriIuran extends StatefulWidget {
  const DaftarKategoriIuran({super.key});

  @override
  State<DaftarKategoriIuran> createState() => _DaftarKategoriIuranState();
}

class _DaftarKategoriIuranState extends State<DaftarKategoriIuran> {
  List<Map<String, dynamic>> kategoriList = [
    {'nama': 'Iuran Kebersihan', 'jumlah': '50000', 'kategori': 'Bulanan'},
    {'nama': 'Iuran Keamanan', 'jumlah': '30000', 'kategori': 'Bulanan'},
    {'nama': 'Iuran Pembangunan', 'jumlah': '100000', 'kategori': 'Tahunan'},
  ];

  bool _showFilter = false;
  final TextEditingController _searchController = TextEditingController();
  String? _filterKategori;

  List<Map<String, dynamic>> get filteredKategori {
    return kategoriList.where((item) {
      final searchMatch = item['nama'].toLowerCase().contains(
        _searchController.text.toLowerCase(),
      );
      final kategoriMatch =
          _filterKategori == null || _filterKategori == '-- Pilih Kategori --'
          ? true
          : item['kategori'] == _filterKategori;
      return searchMatch && kategoriMatch;
    }).toList();
  }

  void _tambahKategori() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TambahKategoriIuran(
          onSubmit: (data) {
            setState(() {
              kategoriList.add(data);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daftar Kategori Iuran',
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
          // Filter
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
                          hintText: 'Cari nama iuran...',
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
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _filterKategori ?? '-- Pilih Kategori --',
                            isExpanded: true,
                            hint: const Text('-- Pilih Kategori --'),
                            items:
                                ['-- Pilih Kategori --', 'Bulanan', 'Tahunan']
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
                        ),
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
              itemCount: filteredKategori.length,
              itemBuilder: (context, index) {
                final item = filteredKategori[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text(item['nama']),
                    subtitle: Text(
                      'Jumlah: Rp ${item['jumlah']}\nKategori: ${item['kategori']}',
                    ),
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailKategoriIuran(
                            data: item,
                            onEdit: (updated) {
                              setState(() {
                                kategoriList[index] = updated;
                              });
                            },
                            onDelete: () {
                              setState(() {
                                kategoriList.removeAt(index);
                              });
                            },
                          ),
                        ),
                      );
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
        label: const Text('Tambah Iuran'),
        onPressed: _tambahKategori,
      ),
    );
  }
}