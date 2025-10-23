import 'package:flutter/material.dart';
import 'package:jawara_pintar_mobile_version/pages/broadcast/detail_broadcast.dart';
import 'package:jawara_pintar_mobile_version/pages/broadcast/edit_broadcast.dart';
import 'package:jawara_pintar_mobile_version/pages/broadcast/tambah_broadcast.dart';

class Broadcast {
  final String id;
  String pengirim;
  String judul;
  DateTime tanggal;
  String isiPesan;

  Broadcast({
    required this.id,
    required this.pengirim,
    required this.judul,
    required this.tanggal,
    required this.isiPesan,
  });
}

class DaftarBroadcast extends StatefulWidget {
  const DaftarBroadcast({super.key});

  @override
  State<DaftarBroadcast> createState() => _DaftarBroadcastState();
}

class _DaftarBroadcastState extends State<DaftarBroadcast> {
  List<Broadcast> dataBroadcast = [
    Broadcast(
      id: 'b1',
      pengirim: 'Admin Jawara',
      judul: 'DJ BAWS',
      tanggal: DateTime(2025, 10, 17),
      isiPesan: 'Ini adalah isi pesan lengkap untuk pengumuman DJ BAWS.',
    ),
    Broadcast(
      id: 'b2',
      pengirim: 'Admin Jawara',
      judul: 'gotong royong',
      tanggal: DateTime(2025, 10, 14),
      isiPesan:
          'Diharapkan kehadiran seluruh warga untuk gotong royong membersihkan lingkungan.',
    ),
    Broadcast(
      id: 'b3',
      pengirim: 'Admin Jawara',
      judul: 'Rapat RT Bulanan',
      tanggal: DateTime(2025, 10, 1),
      isiPesan: 'Rapat RT akan diadakan di balai warga jam 7 malam.',
    ),
    Broadcast(
      id: 'b4',
      pengirim: 'Admin Jawara',
      judul: 'Info Iuran Keamanan',
      tanggal: DateTime(2025, 9, 28),
      isiPesan:
          'Pengumpulan iuran keamanan akan dimulai minggu depan. Mohon disiapkan.',
    ),
    Broadcast(
      id: 'b5',
      pengirim: 'Admin Jawara',
      judul: 'Peringatan: Mati Listrik',
      tanggal: DateTime(2025, 9, 25),
      isiPesan: 'Akan ada pemadaman listrik terjadwal hari Sabtu.',
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

  void _hapusBroadcast(Broadcast broadcast) {
    setState(() {
      dataBroadcast.removeWhere((item) => item.id == broadcast.id);
    });
    Navigator.pop(context); // Tutup dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Broadcast berhasil dihapus'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showDeleteDialog(Broadcast broadcast) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text('Konfirmasi Hapus'),
          content: const Text(
              'Apakah kamu yakin ingin menghapus item ini? Aksi ini tidak dapat dibatalkan.'),
          actions: <Widget>[
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.grey[700],
                side: BorderSide(color: Colors.grey[300]!),
              ),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                _hapusBroadcast(broadcast);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo, // Warna dari gambar
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
        title: const Text('Daftar Broadcast'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: Column(
        children: [
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
                        builder: (context) => const TambahBroadcastPage(),
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
            child: ListView.builder(
              itemCount: dataBroadcast.length,
              
              itemBuilder: (context, index) {
                final Broadcast item = dataBroadcast[index];
                
                final int actualIndex = index + 1;
                    
                final String formattedDate =
                    item.tanggal.toLocal().toString().split(' ')[0];

                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey[100],
                      child: Text(
                        '$actualIndex',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700]),
                      ),
                    ),
                    
                    title: Text(
                      item.judul,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          "Pengirim: ${item.pengirim}",
                          style:
                              TextStyle(color: Colors.grey[700], fontSize: 14),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          formattedDate,
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 12),
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
                                      DetailBroadcastPage(broadcast: item)));
                        } else if (value == 'edit') {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      EditBroadcastPage(broadcast: item)));
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
                      // Gunakan ikon vertikal untuk ListTile
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
    DateTime? dialogStartDate;
    DateTime? dialogEndDate;
    final judulController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Filter Broadcast'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Judul',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 14)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: judulController,
                      decoration: const InputDecoration(
                        hintText: 'Cari judul...',
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text('Dari Tanggal',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 14)),
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
                    const Text('Sampai Tanggal',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 14)),
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
                      judulController.clear();
                      dialogStartDate = null;
                      dialogEndDate = null;
                    });
                    // Logika reset filter
                  },
                  child: const Text('Reset Filter'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Logika terapkan filter
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