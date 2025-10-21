import 'package:flutter/material.dart';
import 'package:jawara_pintar_mobile_version/pages/data_rumah_warga/detail_rumah.dart';

class DaftarRumah extends StatefulWidget {
  const DaftarRumah({super.key});

  @override
  State<DaftarRumah> createState() => _DaftarRumahState();
}

class _DaftarRumahState extends State<DaftarRumah> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedStatus;
  bool _showFilter = false;

  final List<Map<String, dynamic>> rumahList = [
    {
      'no_rumah': 'A-01',
      'alamat': 'Jl. Kenanga No. 10',
      'status': 'Ditempati',
      'kepala_keluarga': 'Budi Santoso',
      'jumlah_anggota': 4,
      'penghuni': [
        'Budi Santoso',
        'Ani Santoso',
        'Rudi Santoso',
        'Rina Santoso',
      ],
    },
    {
      'no_rumah': 'A-02',
      'alamat': 'Jl. Melati No. 5',
      'status': 'Kosong',
      'kepala_keluarga': 'Siti Aminah',
      'jumlah_anggota': 3,
      'penghuni': ['Siti Aminah', 'Ahmad Amin', 'Lina Amin'],
    },
    {
      'no_rumah': 'A-03',
      'alamat': 'Jl. Anggrek No. 3',
      'status': 'Kosong',
      'kepala_keluarga': '-',
      'jumlah_anggota': 0,
      'penghuni': [],
    },
  ];

  List<Map<String, dynamic>> get filteredRumah {
    return rumahList.where((rumah) {
      final searchMatch = rumah['alamat'].toLowerCase().contains(
        _searchController.text.toLowerCase(),
      );
      final statusMatch = _selectedStatus == null || _selectedStatus == 'Semua'
          ? true
          : rumah['status'] == _selectedStatus;
      return searchMatch && statusMatch;
    }).toList();
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Ditempati':
        return Colors.lightGreen.shade800;
      case 'Kosong':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

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
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: const Text(
            'Daftar Rumah Warga',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/kependudukan',
                (route) => false,
              );
            },
          ),
          actions: [
            IconButton(
              icon: Icon(
                _showFilter ? Icons.close : Icons.filter_alt,
                color: Colors.white,
              ),
              tooltip: 'Filter',
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
            // Panel filter 
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
                            hintText: 'Cari berdasarkan alamat...',
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
                                color: Color.fromARGB(255, 45, 92, 21),
                                width: 1.2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                          dropdownColor: Colors.white,
                          iconEnabledColor: const Color.fromARGB(
                            255,
                            45,
                            92,
                            21,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Filter Status Rumah',
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
                          value: _selectedStatus ?? 'Semua',
                          items: const [
                            DropdownMenuItem(
                              value: 'Semua',
                              child: Text('Semua'),
                            ),
                            DropdownMenuItem(
                              value: 'Ditempati',
                              child: Text('Ditempati'),
                            ),
                            DropdownMenuItem(
                              value: 'Kosong',
                              child: Text('Kosong'),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedStatus = value;
                            });
                          },
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  _searchController.clear();
                                  _selectedStatus = 'Semua';
                                });
                              },
                              icon: const Icon(Icons.refresh),
                              label: const Text("Reset"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[300],
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton.icon(
                              onPressed: () {
                                setState(() {});
                              },
                              icon: const Icon(Icons.check_circle),
                              label: const Text("Terapkan"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(
                                  255,
                                  45,
                                  92,
                                  21,
                                ),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
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
              secondChild: const SizedBox.shrink(),
            ),

            const Divider(),

            // Daftar rumah hasil filter
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: filteredRumah.length,
                itemBuilder: (context, index) {
                  final rumah = filteredRumah[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 3,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      title: Text(
                        'No. Rumah: ${rumah['no_rumah']}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('Alamat: ${rumah['alamat']}'),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(rumah['status']),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          rumah['status'],
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailRumah(rumah: rumah),
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
          icon: const Icon(Icons.add_home, color: Colors.white),
          label: const Text(
            'Tambah Rumah',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/tambah_rumah');
          },
        ),
      ),
    );
  }
}