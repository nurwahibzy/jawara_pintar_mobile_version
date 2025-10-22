import 'package:flutter/material.dart';
import 'package:jawara_pintar_mobile_version/pages/kegiatan/kegiatan_detail.dart';
import 'package:jawara_pintar_mobile_version/pages/kegiatan/kegiatan_edit.dart';
import 'package:jawara_pintar_mobile_version/pages/kegiatan/kegiatan_tambah.dart';

class ModelKegiatan {
  final String id;
  String namaKegiatan;
  String kategori;
  DateTime tanggal;
  String lokasi;
  String penanggungJawab;
  String deskripsi;
  String? dokumentasiPath;

  ModelKegiatan({
    required this.id,
    required this.namaKegiatan,
    required this.kategori,
    required this.tanggal,
    required this.lokasi,
    required this.penanggungJawab,
    required this.deskripsi,
    this.dokumentasiPath,
  });
}

class DaftarKegiatan extends StatefulWidget {
  const DaftarKegiatan({super.key});

  @override
  State<DaftarKegiatan> createState() => _DaftarKegiatanState();
}

class _DaftarKegiatanState extends State<DaftarKegiatan> {
  List<ModelKegiatan> dataKegiatan = [
    ModelKegiatan(
      id: 'k1',
      namaKegiatan: 'Musyawarah Warga Bulanan',
      kategori: 'Komunitas & Sosial',
      tanggal: DateTime(2025, 10, 12),
      lokasi: 'Balai Desa',
      penanggungJawab: 'Pak RT',
      deskripsi: 'Rapat rutin membahas kebersihan lingkungan.',
    ),
    ModelKegiatan(
      id: 'k2',
      namaKegiatan: 'Kerja Bakti',
      kategori: 'Komunitas & Sosial',
      tanggal: DateTime(2025, 10, 19),
      lokasi: 'Area Taman',
      penanggungJawab: 'Pak RW',
      deskripsi: 'Membersihkan selokan dan area taman bermain.',
    ),
    ModelKegiatan(
      id: 'k3',
      namaKegiatan: 'Lomba 17-an',
      kategori: 'Acara Khusus',
      tanggal: DateTime(2025, 8, 17),
      lokasi: 'Lapangan Utama',
      penanggungJawab: 'Karang Taruna',
      deskripsi: 'Perlombaan merayakan hari kemerdekaan.',
    ),
  ];

  final List<String> kategoriList = [
    'Komunitas & Sosial',
    'Olahraga',
    'Keagamaan',
    'Acara Khusus',
    'Lainnya',
  ];

  void _hapusKegiatan(ModelKegiatan kegiatan) {
    setState(() {
      dataKegiatan.removeWhere((item) => item.id == kegiatan.id);
    });
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Kegiatan berhasil dihapus'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showDeleteDialog(ModelKegiatan kegiatan) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text('Konfirmasi Hapus'),
          content: const Text(
            'Apakah kamu yakin ingin menghapus item ini? Aksi ini tidak dapat dibatalkan.',
          ),
          actions: <Widget>[
            // Tombol Batal
            OutlinedButton(
              onPressed: () {
                Navigator.pop(context); // Tutup dialog
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.grey[700],
                side: BorderSide(color: Colors.grey[300]!),
              ),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                _hapusKegiatan(kegiatan);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:Colors.green, // Warna biru-ungu seperti di gambar
                foregroundColor: Colors.white,
                elevation: 0,
              ),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Kegiatan'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
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
                        builder: (context) => const TambahKegiatan(),
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
            // Gunakan ListView.builder untuk daftar yang efisien
            child: ListView.builder(
              // Tentukan jumlah item dari list data Anda
              itemCount: dataKegiatan.length,
              // 'itemBuilder' akan membuat satu Card untuk setiap item data
              itemBuilder: (context, index) {
                // Ambil data item saat ini
                final ModelKegiatan item = dataKegiatan[index];
                // Ambil nomor urut
                final int displayIndex = index + 1;
                // Format tanggal
                final String formattedDate = item.tanggal
                    .toLocal()
                    .toString()
                    .split(' ')[0];

                // Kembalikan widget Card
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey[100],
                      child: Text(
                        '$displayIndex',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),

                    title: Text(
                      item.namaKegiatan,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),

                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        // Kategori
                        Text(
                          item.kategori,
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Lokasi & Tanggal
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 12,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                item.lokasi,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.calendar_today,
                              size: 12,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              formattedDate,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    trailing: PopupMenuButton<String>(
                      onSelected: (String value) {
                        if (value == 'detail') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetailKegiatan(kegiatan: item),
                            ),
                          );
                        } else if (value == 'edit') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditKegiatan(kegiatan: item),
                            ),
                          );
                        } else if (value == 'hapus') {
                          _showDeleteDialog(item);
                        }
                      },
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<String>>[
                            const PopupMenuItem<String>(
                              value: 'detail',
                              child: Text('Detail'),
                            ),
                            const PopupMenuItem<String>(
                              value: 'edit',
                              child: Text('Edit'),
                            ),
                            const PopupMenuItem<String>(
                              value: 'hapus',
                              child: Text('Hapus'),
                            ),
                          ],
                      icon: const Icon(Icons.more_vert),
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

  void _showFilterDialog(BuildContext context) {
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
              title: const Text('Filter Kegiatan'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Nama Kegiatan',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: namaController,
                      decoration: const InputDecoration(
                        hintText: 'Cari nama kegiatan...',
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
                      initialValue: dialogSelectedKategori,
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
                    // Logika filter diterapkan di sini
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
