import 'package:flutter/material.dart';
import 'package:jawara_pintar_mobile_version/pages/manajemen_pengguna/detail_pengguna.dart';
import 'package:jawara_pintar_mobile_version/pages/manajemen_pengguna/edit_pengguna.dart';
import 'package:jawara_pintar_mobile_version/pages/manajemen_pengguna/tambah_pengguna.dart';

// Halaman List Pengguna
class DaftarPengguna extends StatefulWidget {
  const DaftarPengguna({super.key});

  @override
  State<DaftarPengguna> createState() => _DaftarPenggunaState();
}

class _DaftarPenggunaState extends State<DaftarPengguna> {
  List<dynamic> dataPengguna = [
    {
      'id': '1',
      'nama': 'Budi Santoso',
      'nik': '3201234567890001',
      'email': 'budi.santoso@email.com',
      'role': 'Admin',
      'statusAkun': 'Diterima',
      'noTelepon': '081234567890',
      'jenisKelamin': 'Laki-laki',
      'alamat': 'Blok A5',
      'tanggalBergabung': DateTime(2024, 1, 15),
      'terakhirLogin': DateTime(2025, 10, 22),
    },
    {
      'id': '2',
      'nama': 'Siti Aminah',
      'nik': '3201234567890002',
      'email': 'siti.aminah@email.com',
      'role': 'Ketua RT',
      'statusAkun': 'Diterima',
      'noTelepon': '081234567891',
      'jenisKelamin': 'Perempuan',
      'alamat': 'Blok A4',
      'tanggalBergabung': DateTime(2024, 3, 10),
      'terakhirLogin': DateTime(2025, 10, 21),
    },
    {
      'id': '3',
      'nama': 'Ahmad Rizki',
      'nik': '3201234567890003',
      'email': 'ahmad.rizki@email.com',
      'role': 'Ketua RW',
      'statusAkun': 'Diterima',
      'noTelepon': '081234567892',
      'jenisKelamin': 'Laki-laki',
      'alamat': 'Blok A3',
      'tanggalBergabung': DateTime(2024, 5, 20),
      'terakhirLogin': DateTime(2025, 9, 15),
    },
    {
      'id': '4',
      'nama': 'Rina Wijaya',
      'nik': '3201234567890004',
      'email': 'rina.wijaya@email.com',
      'role': 'Bendahara',
      'statusAkun': 'Diterima',
      'noTelepon': '081234567893',
      'jenisKelamin': 'Perempuan',
      'alamat': 'Blok B2',
      'tanggalBergabung': DateTime(2024, 2, 5),
      'terakhirLogin': DateTime(2025, 10, 22),
    },
    {
      'id': '5',
      'nama': 'Dedi Susanto',
      'nik': '3201234567890005',
      'email': 'dedi.susanto@email.com',
      'role': 'Sekretaris',
      'statusAkun': 'Diterima',
      'noTelepon': '081234567894',
      'jenisKelamin': 'Laki-laki',
      'alamat': 'Blok C1',
      'tanggalBergabung': DateTime(2024, 4, 12),
      'terakhirLogin': DateTime(2025, 10, 20),
    },
    {
      'id': '6',
      'nama': 'Putri Handayani',
      'nik': '3201234567890006',
      'email': 'putri.handayani@email.com',
      'role': 'Warga',
      'statusAkun': 'Diterima',
      'noTelepon': '081234567895',
      'jenisKelamin': 'Perempuan',
      'alamat': 'Blok D3',
      'tanggalBergabung': DateTime(2024, 6, 8),
      'terakhirLogin': DateTime(2025, 10, 19),
    },
  ];

  // List untuk Filter
  final List<String> roleList = [
    'Admin',
    'Ketua RT',
    'Ketua RW',
    'Sekretaris',
    'Bendahara',
    'Warga',
  ];

  final List<String> statusAkunList = [
    'Diterima',
    'Tidak Diterima',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Manajemen Pengguna',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.green),
      ),
      body: Column(
        children: [
          // Header dengan tombol Tambah Pengguna dan Filter
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // Navigasi ke halaman Tambah Pengguna
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TambahPengguna(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.person_add, size: 18),
                  label: const Text('Tambah Pengguna'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    _showFilterDialog(context);
                  },
                  icon: const Icon(Icons.filter_list, size: 18),
                  label: const Text('Filter'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: dataPengguna.length,
              itemBuilder: (context, index) {
                final dynamic item = dataPengguna[index];

                // Format data untuk ditampilkan
                final String formattedBergabung =
                    '${_getMonthName(item['tanggalBergabung'].month)} ${item['tanggalBergabung'].year}';
                final String formattedTerakhirLogin =
                    '${item['terakhirLogin'].day} ${_getMonthName(item['terakhirLogin'].month)} ${item['terakhirLogin'].year}';

                // Tentukan warna status akun
                Color statusColor = item['statusAkun'] == 'Diterima'
                    ? Colors.green
                    : Colors.red;

                // Tentukan warna role
                Color roleColor = item['role'] == 'Admin'
                    ? Colors.blue
                    : item['role'] == 'Ketua RT'
                        ? Colors.deepPurple
                        : item['role'] == 'Ketua RW'
                            ? Colors.indigo
                            : item['role'] == 'Sekretaris'
                                ? Colors.teal
                                : item['role'] == 'Bendahara'
                                    ? Colors.purple
                                    : Colors.orange;

                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Baris 1: Nama dan Status Akun
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                item['nama'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: statusColor.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    item['statusAkun'],
                                    style: TextStyle(
                                      color: statusColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                // Tombol Aksi (PopupMenuButton)
                                Container(
                                  width: 40,
                                  alignment: Alignment.topRight,
                                  child: PopupMenuButton<String>(
                                    onSelected: (String value) {
                                      if (value == 'detail') {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                DetailPengguna(pengguna: item),
                                          ),
                                        );
                                      } else if (value == 'edit') {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                EditPengguna(pengguna: item),
                                          ),
                                        );
                                      }
                                    },
                                    itemBuilder: (BuildContext context) =>
                                        <PopupMenuEntry<String>>[
                                      const PopupMenuItem<String>(
                                        value: 'detail',
                                        child: Row(
                                          children: [
                                            Icon(Icons.info_outline,
                                                size: 20, color: Colors.blue),
                                            SizedBox(width: 8),
                                            Text('Detail'),
                                          ],
                                        ),
                                      ),
                                      const PopupMenuItem<String>(
                                        value: 'edit',
                                        child: Row(
                                          children: [
                                            Icon(Icons.edit,
                                                size: 20, color: Colors.orange),
                                            SizedBox(width: 8),
                                            Text('Edit'),
                                          ],
                                        ),
                                      ),
                                    ],
                                    icon: const Icon(Icons.more_vert,
                                        color: Colors.grey),
                                    padding: EdgeInsets.zero,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Baris 2: Email
                        Row(
                          children: [
                            Icon(Icons.email,
                                size: 16, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                item['email'],
                                style: TextStyle(
                                    color: Colors.grey[700], fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),

                        // Baris 3: Role
                        Row(
                          children: [
                            Icon(Icons.badge,
                                size: 16, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: roleColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                item['role'],
                                style: TextStyle(
                                    color: roleColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),

                        // Baris 4: No Telepon
                        Row(
                          children: [
                            Icon(Icons.phone,
                                size: 16, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Text(
                              item['noTelepon'],
                              style: TextStyle(
                                  color: Colors.grey[700], fontSize: 14),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),

                        // Baris 5: Alamat
                        Row(
                          children: [
                            Icon(Icons.location_on,
                                size: 16, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Text(
                              item['alamat'],
                              style: TextStyle(
                                  color: Colors.grey[700], fontSize: 14),
                            ),
                          ],
                        ),

                        // Pemisah
                        const Divider(height: 24),

                        // Baris 6: Info Tambahan (di bagian bawah)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Bergabung',
                                  style: TextStyle(
                                      color: Colors.grey[600], fontSize: 11),
                                ),
                                Text(
                                  formattedBergabung,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Terakhir Login',
                                  style: TextStyle(
                                      color: Colors.grey[600], fontSize: 11),
                                ),
                                Text(
                                  formattedTerakhirLogin,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];
    return months[month - 1];
  }

  void _showFilterDialog(BuildContext context) {
    String? dialogRole;
    String? dialogStatusAkun;
    TextEditingController searchController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Filter Pengguna'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search Nama
                    const Text(
                      'Cari Nama',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'Masukkan nama pengguna...',
                        prefixIcon: const Icon(Icons.search, size: 20),
                        border: const OutlineInputBorder(),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        suffixIcon: searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, size: 20),
                                onPressed: () {
                                  setDialogState(() {
                                    searchController.clear();
                                  });
                                },
                              )
                            : null,
                      ),
                      onChanged: (value) {
                        setDialogState(() {});
                      },
                    ),
                    const SizedBox(height: 16),

                    // Role
                    const Text(
                      'Role',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      initialValue: dialogRole,
                      decoration: const InputDecoration(
                        hintText: '-- Pilih Role --',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      items: roleList.map((String role) {
                        return DropdownMenuItem<String>(
                          value: role,
                          child: Text(role),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setDialogState(() {
                          dialogRole = newValue;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // Status Akun
                    const Text(
                      'Status Akun',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      initialValue: dialogStatusAkun,
                      decoration: const InputDecoration(
                        hintText: '-- Pilih Status Akun --',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      items: statusAkunList.map((String status) {
                        return DropdownMenuItem<String>(
                          value: status,
                          child: Text(status),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setDialogState(() {
                          dialogStatusAkun = newValue;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                OutlinedButton(
                  onPressed: () {
                    setDialogState(() {
                      searchController.clear();
                      dialogRole = null;
                      dialogStatusAkun = null;
                    });
                  },
                  child: const Text('Reset Filter'),
                ),
                ElevatedButton(
                  onPressed: () {
                    print('Filter Diterapkan:');
                    print('Nama: ${searchController.text}');
                    print('Role: $dialogRole');
                    print('Status Akun: $dialogStatusAkun');
                    Navigator.pop(dialogContext);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Terapkan'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
