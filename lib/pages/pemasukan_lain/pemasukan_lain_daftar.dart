import 'package:flutter/material.dart';
import 'package:jawara_pintar_mobile_version/pages/pemasukan_lain/pemasukan_lain_detail.dart';
import 'package:jawara_pintar_mobile_version/pages/pemasukan_lain/pemasukan_lain_tambah.dart';

class Pemasukan {
  final String id;
  final String nama;
  final String jenisPemasukan;
  final DateTime tanggal;
  final double nominal;
  final String? buktiPath;

  Pemasukan({
    required this.id,
    required this.nama,
    required this.jenisPemasukan,
    required this.tanggal,
    required this.nominal,
    this.buktiPath,
  });
}

// Halaman List Pemasukan
class PemasukanLain extends StatefulWidget {
  const PemasukanLain({super.key});

  @override
  State<PemasukanLain> createState() => _PemasukanLainState();
}

class _PemasukanLainState extends State<PemasukanLain> {
  List<Pemasukan> dataPemasukan = [
    Pemasukan(
      id: '1',
      nama: 'aaaaa',
      jenisPemasukan: 'Dana Bantuan Pemerintah',
      tanggal: DateTime(2025, 10, 15),
      nominal: 11.00,
    ),
    Pemasukan(
      id: '2',
      nama: 'Joki by firman',
      jenisPemasukan: 'Pendapatan Lainnya',
      tanggal: DateTime(2025, 10, 13),
      nominal: 49999997.00,
    ),
    Pemasukan(
      id: '3',
      nama: 'tes',
      jenisPemasukan: 'Pendapatan Lainnya',
      tanggal: DateTime(2025, 8, 12),
      nominal: 10000.00,
    ),
  ];

  // List Kategori untuk Filter Dialog
  final List<String> kategoriList = [
    'Dana Bantuan Pemerintah',
    'Pendapatan Lainnya',
    'Donasi',
    'Hibah',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pemasukan',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.green),
      ),
      body: Column(
        children: [
          // Header dengan tombol Tambah dan Filter
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TambahPemasukanLain(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Tambah'),
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
            // Gunakan ListView.builder untuk membuat daftar yang bisa di-scroll
            child: ListView.builder(
              // Tentukan jumlah item berdasarkan panjang data Anda
              itemCount: dataPemasukan.length,
              itemBuilder: (context, index) {
                // Ambil satu item data
                final Pemasukan item = dataPemasukan[index];

                // Format data untuk ditampilkan
                final String formattedDate =
                    item.tanggal.toLocal().toString().split(' ')[0];
                final String formattedNominal =
                    'Rp ${item.nominal.toStringAsFixed(2)}';

                // Buat widget Card untuk setiap item
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
                        // Baris 1: Nama Pemasukan dan Tombol Aksi
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Nama Pemasukan (dibuat Expanded agar tidak overflow)
                            Expanded(
                              child: Text(
                                item.nama,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
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
                                            DetailPemasukanLain(
                                                pemasukan: item),
                                      ),
                                    );
                                  }
                                  // Tambahkan 'edit' atau 'hapus' di sini jika perlu
                                },
                                itemBuilder: (BuildContext context) =>
                                    <PopupMenuEntry<String>>[
                                  const PopupMenuItem<String>(
                                    value: 'detail',
                                    child: Text('Detail'),
                                  ),
                                ],
                                icon: const Icon(Icons.more_vert,
                                    color: Colors.grey),
                                padding: EdgeInsets.zero,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Baris 2: Jenis Pemasukan
                        Text(
                          item.jenisPemasukan,
                          style:
                              TextStyle(color: Colors.grey[700], fontSize: 14),
                        ),
                        const SizedBox(height: 4),

                        // Baris 3: Tanggal
                        Text(
                          formattedDate,
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 12),
                        ),

                        // Pemisah
                        const Divider(height: 24),

                        // Baris 4: Nominal (di bagian bawah)
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            formattedNominal,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.green, // Diberi warna agar menonjol
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
          // Pagination
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ... (Widget pagination Anda)
              ],
            ),
          ),
        ],
      ),
      
    );
  }

  void _showFilterDialog(BuildContext context) {
    // ... (Fungsi dialog filter Anda tidak berubah)
    String? dialogSelectedKategori;
    DateTime? dialogStartDate;
    DateTime? dialogEndDate;
    final namaController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Filter Pemasukan Non Iuran'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Nama',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: namaController,
                      decoration: const InputDecoration(
                        hintText: 'Cari nama...',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Kategori',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: dialogSelectedKategori,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      hint: const Text('-- Pilih Kategori --'),
                      items: kategoriList.map((String kategori) {
                        return DropdownMenuItem<String>(
                          value: kategori,
                          child: Text(kategori),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setDialogState(() {
                          dialogSelectedKategori = newValue;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Dari Tanggal',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildDatePickerField(
                      context: context,
                      selectedDate: dialogStartDate,
                      onDateSelected: (date) {
                        setDialogState(() {
                          dialogStartDate = date;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Sampai Tanggal',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildDatePickerField(
                      context: context,
                      selectedDate: dialogEndDate,
                      onDateSelected: (date) {
                        setDialogState(() {
                          dialogEndDate = date;
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
                      namaController.clear();
                      dialogSelectedKategori = null;
                      dialogStartDate = null;
                      dialogEndDate = null;
                    });
                  },
                  child: const Text('Reset Filter'),
                ),
                ElevatedButton(
                  onPressed: () {
                    print('Filter Diterapkan:');
                    print('Nama: ${namaController.text}');
                    print('Kategori: $dialogSelectedKategori');
                    print('Dari: $dialogStartDate');
                    print('Sampai: $dialogEndDate');
                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Terapkan'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildDatePickerField({
    required BuildContext context,
    required DateTime? selectedDate,
    required ValueChanged<DateTime> onDateSelected,
  }) {
    // ... (Fungsi helper date picker tidak berubah)
    return InkWell(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (picked != null) {
          onDateSelected(picked);
        }
      },
      child: InputDecorator(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          suffixIcon: Icon(Icons.calendar_today),
        ),
        child: Text(
          selectedDate == null
              ? 'Pilih tanggal'
              : selectedDate.toLocal().toString().split(' ')[0],
          style: TextStyle(
            color: selectedDate == null ? Colors.grey[700] : Colors.black,
          ),
        ),
      ),
    );
  }
}
