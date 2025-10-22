import 'package:flutter/material.dart';
import 'package:jawara_pintar_mobile_version/pages/tagihan/detail_tagihan.dart';

// Halaman List Tagihan Warga
class DaftarTagihan extends StatefulWidget {
  const DaftarTagihan({super.key});

  @override
  State<DaftarTagihan> createState() => _DaftarTagihanState();
}

class _DaftarTagihanState extends State<DaftarTagihan> {
  List<dynamic> dataTagihan = [
    {
      'id': '1',
      'namaWarga': 'Budi Santoso',
      'statusPembayaran': 'Lunas',
      'statusKeluarga': 'Aktif',
      'keluarga': 'Keluarga Santoso',
      'alamat' : 'Blok A5',
      'jenisIuran': 'Iuran Bulanan',
      'periode': DateTime(2025, 10),
      'nominal': 150000.00,
    },
    {
      'id': '2',
      'namaWarga': 'Siti Aminah',
      'statusPembayaran': 'Belum Lunas',
      'statusKeluarga': 'Aktif',
      'keluarga': 'Keluarga Aminah',
      'alamat' : 'Blok A4',
      'jenisIuran': 'Iuran Kebersihan',
      'periode': DateTime(2025, 10),
      'nominal': 50000.00,
    },
    {
      'id': '3',
      'namaWarga': 'Ahmad Rizki',
      'statusPembayaran': 'Belum Lunas',
      'statusKeluarga': 'Nonaktif',
      'keluarga': 'Keluarga Rizki',
      'alamat' : 'Blok A3',
      'jenisIuran': 'Iuran Keamanan',
      'periode': DateTime(2025, 9),
      'nominal': 100000.00,
    },
  ];

  // List untuk Filter
  final List<String> statusPembayaranList = [
    'Lunas',
    'Belum Lunas',
  ];

  final List<String> statusKeluargaList = [
    'Aktif',
    'Nonaktif',
  ];

  final List<String> keluargaList = [
    'Keluarga Santoso',
    'Keluarga Aminah',
    'Keluarga Rizki',
    'Keluarga Budiman',
  ];

  final List<String> iuranList = [
    'Iuran Bulanan',
    'Iuran Kebersihan',
    'Iuran Keamanan',
    'Iuran Lainnya',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tagihan Warga',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.green),
      ),
      body: Column(
        children: [
          // Header dengan tombol Cetak PDF dan Filter
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // Fungsi cetak PDF (hanya tampilan)
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Fitur Cetak PDF'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: const Icon(Icons.picture_as_pdf, size: 18),
                  label: const Text('Cetak PDF'),
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
              itemCount: dataTagihan.length,
              itemBuilder: (context, index) {
                final dynamic item = dataTagihan[index];

                // Format data untuk ditampilkan
                final String formattedPeriode =
                    '${_getMonthName(item['periode'].month)} ${item['periode'].year}';
                final String formattedNominal =
                    'Rp ${item['nominal'].toStringAsFixed(0).replaceAllMapped(
                          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                          (Match m) => '${m[1]}.',
                        )}';

                // Tentukan warna status pembayaran
                Color statusColor = item['statusPembayaran'] == 'Lunas'
                    ? Colors.green
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
                        // Baris 1: Nama Warga dan Status Pembayaran
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                item['namaWarga'],
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
                                    item['statusPembayaran'],
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
                                                DetailTagihan(tagihan: item),
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

                        // Baris 2: Keluarga
                        Row(
                          children: [
                            Icon(Icons.family_restroom,
                                size: 16, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Text(
                              item['keluarga'],
                              style: TextStyle(
                                  color: Colors.grey[700], fontSize: 14),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),

                        // Baris 3: Jenis Iuran
                        Row(
                          children: [
                            Icon(Icons.payment,
                                size: 16, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Text(
                              item['jenisIuran'],
                              style: TextStyle(
                                  color: Colors.grey[700], fontSize: 14),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),

                        // Baris 4: Periode
                        Row(
                          children: [
                            Icon(Icons.calendar_today,
                                size: 16, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Text(
                              formattedPeriode,
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 12),
                            ),
                          ],
                        ),

                        // Pemisah
                        const Divider(height: 24),

                        // Baris 5: Nominal (di bagian bawah)
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            formattedNominal,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: statusColor,
                            ),
                          ),
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
    String? dialogStatusPembayaran;
    String? dialogStatusKeluarga;
    String? dialogKeluarga;
    String? dialogIuran;
    DateTime? dialogPeriode;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Filter Tagihan Warga'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status Pembayaran
                    const Text(
                      'Status Pembayaran',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: dialogStatusPembayaran,
                      decoration: const InputDecoration(
                        hintText: '-- Pilih Status --',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      items: statusPembayaranList.map((String status) {
                        return DropdownMenuItem<String>(
                          value: status,
                          child: Text(status),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setDialogState(() {
                          dialogStatusPembayaran = newValue;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // Status Keluarga
                    const Text(
                      'Status Keluarga',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: dialogStatusKeluarga,
                      decoration: const InputDecoration(
                        hintText: '-- Pilih Status Keluarga--',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      items: statusKeluargaList.map((String status) {
                        return DropdownMenuItem<String>(
                          value: status,
                          child: Text(status),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setDialogState(() {
                          dialogStatusKeluarga = newValue;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // Keluarga
                    const Text(
                      'Keluarga',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: dialogKeluarga,
                      decoration: const InputDecoration(
                        hintText: '-- Pilih Keluarga --',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      items: keluargaList.map((String keluarga) {
                        return DropdownMenuItem<String>(
                          value: keluarga,
                          child: Text(keluarga),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setDialogState(() {
                          dialogKeluarga = newValue;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // Iuran
                    const Text(
                      'Iuran',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: dialogIuran,
                      decoration: const InputDecoration(
                        hintText: '-- Pilih Iuran --',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      items: iuranList.map((String iuran) {
                        return DropdownMenuItem<String>(
                          value: iuran,
                          child: Text(iuran),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setDialogState(() {
                          dialogIuran = newValue;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // Periode (Bulan & Tahun)
                    const Text(
                      'Periode (Bulan & Tahun)',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: dialogPeriode ?? DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                          initialDatePickerMode: DatePickerMode.year,
                        );
                        if (picked != null) {
                          setDialogState(() {
                            dialogPeriode = picked;
                          });
                        }
                      },
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          hintText: '--/----',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        child: Text(
                          dialogPeriode == null
                              ? '--/----'
                              : '${dialogPeriode!.month.toString().padLeft(2, '0')}/${dialogPeriode!.year}',
                          style: TextStyle(
                            color: dialogPeriode == null
                                ? Colors.grey[600]
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                OutlinedButton(
                  onPressed: () {
                    setDialogState(() {
                      dialogStatusPembayaran = null;
                      dialogStatusKeluarga = null;
                      dialogKeluarga = null;
                      dialogIuran = null;
                      dialogPeriode = null;
                    });
                  },
                  child: const Text('Reset Filter'),
                ),
                ElevatedButton(
                  onPressed: () {
                    print('Filter Diterapkan:');
                    print('Status Pembayaran: $dialogStatusPembayaran');
                    print('Status Keluarga: $dialogStatusKeluarga');
                    print('Keluarga: $dialogKeluarga');
                    print('Iuran: $dialogIuran');
                    print('Periode: $dialogPeriode');
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
