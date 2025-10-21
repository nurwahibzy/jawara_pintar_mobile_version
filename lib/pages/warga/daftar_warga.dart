import 'package:flutter/material.dart';
import 'package:jawara_pintar_mobile_version/pages/warga/detail_warga.dart';

class DaftarWarga extends StatefulWidget {
  const DaftarWarga({super.key});

  @override
  State<DaftarWarga> createState() => _DaftarWargaState();
}

class _DaftarWargaState extends State<DaftarWarga> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedStatus;
  bool _showFilter = false;

  // Data dummy sementara
  final List<Map<String, dynamic>> wargaList = [
    {
      'keluarga': 'Keluarga A',
      'nama': 'Budi Santoso',
      'nik': '31740510010001',
      'telepon': '081234567890',
      'tempat_lahir': 'Jakarta',
      'tanggal_lahir': '1990-04-12',
      'jenis_kelamin': 'Laki - Laki',
      'agama': 'Islam',
      'golongan_darah': 'O',
      'peran_keluarga': 'Ayah',
      'pendidikan': 'Sarjana',
      'pekerjaan': 'PNS',
      'status': 'Aktif',
      'alamat': 'Jl. Kenanga No. 10',
      'no_rumah': 'A-01',
    },
    {
      'keluarga': 'Keluarga B',
      'nama': 'Siti Aminah',
      'nik': '31740510010002',
      'telepon': '081298765432',
      'tempat_lahir': 'Bandung',
      'tanggal_lahir': '1992-08-25',
      'jenis_kelamin': 'Perempuan',
      'agama': 'Islam',
      'golongan_darah': 'A',
      'peran_keluarga': 'Ibu',
      'pendidikan': 'SMA',
      'pekerjaan': 'Wiraswasta',
      'status': 'Tidak Aktif',
      'alamat': 'Jl. Melati No. 5',
      'no_rumah': 'A-02',
    },
    {
      'keluarga': 'Keluarga B',
      'nama': 'Ahmad Amin',
      'nik': '31740510010003',
      'telepon': '081355667788',
      'tempat_lahir': 'Bandung',
      'tanggal_lahir': '2010-05-17',
      'jenis_kelamin': 'Laki - Laki',
      'agama': 'Islam',
      'golongan_darah': 'B',
      'peran_keluarga': 'Anak',
      'pendidikan': 'SMP',
      'pekerjaan': 'Pelajar/Mahasiswa',
      'status': 'Aktif',
      'alamat': 'Jl. Melati No. 5',
      'no_rumah': 'A-02',
    },
    {
      'keluarga': 'Keluarga C',
      'nama': 'Maria Kristina',
      'nik': '31740510010004',
      'telepon': '081345678901',
      'tempat_lahir': 'Surabaya',
      'tanggal_lahir': '1988-02-10',
      'jenis_kelamin': 'Perempuan',
      'agama': 'Kristen',
      'golongan_darah': 'AB',
      'peran_keluarga': 'Ibu',
      'pendidikan': 'Diploma',
      'pekerjaan': 'BUMN',
      'status': 'Aktif',
      'alamat': 'Jl. Anggrek No. 7',
      'no_rumah': 'B-03',
    },
    {
      'keluarga': 'Keluarga C',
      'nama': 'Andreas Kristino',
      'nik': '31740510010005',
      'telepon': '081322334455',
      'tempat_lahir': 'Surabaya',
      'tanggal_lahir': '1986-11-03',
      'jenis_kelamin': 'Laki - Laki',
      'agama': 'Kristen',
      'golongan_darah': 'O',
      'peran_keluarga': 'Ayah',
      'pendidikan': 'Sarjana',
      'pekerjaan': 'Wiraswasta',
      'status': 'Aktif',
      'alamat': 'Jl. Anggrek No. 7',
      'no_rumah': 'B-03',
    },
  ];


  List<Map<String, dynamic>> get filteredWarga {
    return wargaList.where((warga) {
      final searchMatch = warga['nama'].toLowerCase().contains(
        _searchController.text.toLowerCase(),
      );
      final statusMatch = _selectedStatus == null || _selectedStatus == 'Semua'
          ? true
          : warga['status'] == _selectedStatus;
      return searchMatch && statusMatch;
    }).toList();
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Aktif':
        return Colors.green.shade700;
      case 'Tidak Aktif':
        return Colors.red.shade700;
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
            'Daftar Warga',
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
            // Filter Panel
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
                            hintText: 'Cari berdasarkan nama...',
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
                          iconEnabledColor: const Color.fromARGB(255,45, 92, 21,),
                          decoration: InputDecoration(
                            labelText: 'Filter Status Kependudukan',
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
                              value: 'Aktif',
                              child: Text('Aktif'),
                            ),
                            DropdownMenuItem(
                              value: 'Tidak Aktif',
                              child: Text('Tidak Aktif'),
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
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
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

            // Daftar warga
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: filteredWarga.length,
                itemBuilder: (context, index) {
                  final warga = filteredWarga[index];
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
                        warga['nama'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${warga['keluarga']}'),
                          Text('Alamat: ${warga['alamat']}'),
                        ],
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(warga['status']),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          warga['status'],
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailWarga(warga: warga),
                          ),
                        );

                        if (result == 'hapus') {
                          setState(() {
                            wargaList.remove(warga);
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

        //Tombol Tambah Warga
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.green,
          icon: const Icon(Icons.person_add, color: Colors.white),
          label: const Text(
            'Tambah Warga',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/tambah_warga');
          },
        ),
      ),
    );
  }
}