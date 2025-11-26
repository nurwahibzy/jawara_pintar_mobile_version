import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:jawara_pintar_mobile_version/features/mutasi-keluarga/data/models/mutasi_keluarga_models.dart';
// import 'package:jawara_pintar_mobile_version/features/mutasi-keluarga/domain/entities/mutasi_keluarga.dart';
import 'package:jawara_pintar_mobile_version/features/mutasi-keluarga/presentation/bloc/mutasi_keluarga_bloc.dart';

class TambahMutasiKeluarga extends StatefulWidget {
  const TambahMutasiKeluarga({super.key});

  @override
  State<TambahMutasiKeluarga> createState() => _TambahMutasiKeluargaState();
}

class _TambahMutasiKeluargaState extends State<TambahMutasiKeluarga> {
  final _formKey = GlobalKey<FormState>();

  // --- CONTROLLERS & STATE VARIABLES ---
  final TextEditingController _keteranganController = TextEditingController();
  final TextEditingController _tanggalController = TextEditingController();

  // Variable untuk menampung nilai yang dipilih dari Dropdown
  int? _selectedKeluargaId;
  String? _selectedJenisMutasi;
  int? _selectedRumahAsalId;
  int? _selectedRumahTujuanId;
  DateTime? _selectedDate;

  // List opsi Jenis Mutasi (Tetap statis karena Enum/Pilihan Tetap)
  final List<String> _listJenisMutasi = [
    'Pindah Rumah',
    'Keluar Wilayah',
    'Masuk Baru',
  ];

  @override
  void initState() {
    super.initState();
    // Panggil Event untuk load data dropdown dari Supabase saat halaman dibuka
    context.read<MutasiKeluargaBloc>().add(MutasiKeluargaEventLoadForm());
  }

  @override
  void dispose() {
    _keteranganController.dispose();
    _tanggalController.dispose();
    super.dispose();
  }

  // Fungsi Memilih Tanggal
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _tanggalController.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  void _simpanData() {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tanggal Mutasi wajib diisi')),
        );
        return;
      }

      // Membuat Object Entity
      final mutasiBaru = MutasiKeluargaModel(
        keluargaId: _selectedKeluargaId!,
        jenisMutasi: _selectedJenisMutasi!,
        rumahAsalId: _selectedRumahAsalId,
        rumahTujuanId: _selectedRumahTujuanId,
        tanggalMutasi: _selectedDate!,
        keterangan: _keteranganController.text.isEmpty
            ? null
            : _keteranganController.text,
        fileBukti: null,
        createdAt: DateTime.now(),
      );

      // Kirim event Create ke Bloc
      context.read<MutasiKeluargaBloc>().add(
        MutasiKeluargaEventCreate(mutasiBaru),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Form Mutasi Keluarga')),
      // BlocListener untuk menangani hasil Sukses/Gagal Simpan
      body: BlocListener<MutasiKeluargaBloc, MutasiKeluargaState>(
        listener: (context, state) {
          if (state is MutasiKeluargaActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context, true); // Kembali ke list
          } else if (state is MutasiKeluargaError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        // BlocBuilder untuk menangani Load Data Form (Dropdown)
        child: BlocBuilder<MutasiKeluargaBloc, MutasiKeluargaState>(
          builder: (context, state) {
            // 1. KONDISI LOADING (Sedang ambil data dropdown atau sedang simpan)
            if (state is MutasiKeluargaLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            // 2. KONDISI ERROR (Gagal ambil data dropdown)
            if (state is MutasiKeluargaError) {
              // Note: Jika error terjadi saat "Simpan", form akan hilang dan muncul pesan ini.
              // Untuk UX lebih baik, bisa tambahkan tombol "Reload Form".
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message, textAlign: TextAlign.center),
                    ElevatedButton(
                      onPressed: () => context.read<MutasiKeluargaBloc>().add(
                        MutasiKeluargaEventLoadForm(),
                      ),
                      child: const Text("Coba Lagi"),
                    ),
                  ],
                ),
              );
            }

            // 3. KONDISI READY (Data Dropdown tersedia)
            if (state is MutasiKeluargaFormReady) {
              final listKeluargaSupabase = state.listKeluarga;
              final listRumahSupabase = state.listRumah;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. INPUT KELUARGA (Required Dropdown - Data dari Supabase)
                      // Ganti Widget Dropdown Keluarga dengan ini:
                      DropdownButtonFormField<int>(
                        decoration: const InputDecoration(
                          labelText: 'Pilih Keluarga ',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.family_restroom),
                        ),
                        value: _selectedKeluargaId,
                        items: listKeluargaSupabase
                            // 1. FILTER: Hanya ambil keluarga yang punya data warga
                            .where((item) {
                              final w = item['warga'];
                              return w != null && (w as List).isNotEmpty;
                            })
                            // 2. MAP: Baru setelah itu kita ubah jadi DropdownMenuItem
                            .map<DropdownMenuItem<int>>((item) {
                              // Logika mencari nama (seperti sebelumnya)
                              String namaDitampilkan =
                                  "KK: ${item['nomor_kk']}";

                              final listWarga = item['warga'] as List;
                              // Cari Kepala Keluarga
                              final kepala = listWarga.firstWhere(
                                (w) =>
                                    w['status_keluarga'] == 'Kepala Keluarga',
                                orElse: () => listWarga.first,
                              );

                              if (kepala != null) {
                                namaDitampilkan =
                                    "${kepala['nama_lengkap']} (${item['nomor_kk']})";
                              }

                              return DropdownMenuItem<int>(
                                value: item['id'] as int,
                                child: Text(namaDitampilkan),
                              );
                            })
                            .toList(),
                        onChanged: (value) {
                          // setState(() {
                            _selectedKeluargaId = value;

                          //   // Set Rumah Asal berdasarkan Keluarga yang dipilih
                          //   final keluargaDipilih = listKeluargaSupabase.firstWhere(
                          //     (item) => item['id'] == value,
                          //     orElse: () => null,
                          //   );
                          //   if (keluargaDipilih != null) {
                          //     _selectedRumahAsalId = keluargaDipilih['rumah_id'] as int?;
                          //   } else {
                          //     _selectedRumahAsalId = null;
                          //   }
                          // });
                        },
                        validator: (val) =>
                            val == null ? 'Keluarga wajib dipilih' : null,
                      ),
                      const SizedBox(height: 16),

                      // 2. INPUT JENIS MUTASI (Required Dropdown - Static)
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Jenis Mutasi ',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.swap_horiz),
                        ),
                        initialValue: _selectedJenisMutasi,
                        items: _listJenisMutasi.map((jenis) {
                          return DropdownMenuItem<String>(
                            value: jenis,
                            child: Text(jenis),
                          );
                        }).toList(),
                        onChanged: (value) =>
                            setState(() => _selectedJenisMutasi = value),
                        validator: (val) =>
                            val == null ? 'Jenis Mutasi wajib dipilih' : null,
                      ),
                      const SizedBox(height: 16),

                      // 3. INPUT TANGGAL (Required Date Picker)
                      TextFormField(
                        controller: _tanggalController,
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: 'Tanggal Mutasi ',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.calendar_today),
                          suffixIcon: Icon(Icons.arrow_drop_down),
                        ),
                        onTap: () => _selectDate(context),
                        validator: (val) =>
                            val!.isEmpty ? 'Tanggal wajib diisi' : null,
                      ),
                      const SizedBox(height: 16),

                      // 4. INPUT RUMAH ASAL (Optional Dropdown - Data dari Supabase)
                      // DropdownButtonFormField<int>(
                      //   decoration: const InputDecoration(
                      //     labelText: 'Rumah Asal (Otomatis)',
                      //     border: OutlineInputBorder(),
                      //     prefixIcon: Icon(Icons.home_outlined),
                      //   ),
                      //   // Penting: Gunakan 'value', bukan 'initialValue' agar berubah saat setState
                      //   value: _selectedRumahAsalId,
                      //   items: listRumahSupabase.map<DropdownMenuItem<int>>((
                      //     item,
                      //   ) {
                      //     return DropdownMenuItem<int>(
                      //       value: item['id'] as int,
                      //       child: Text("Blok ${item['blok_nomor'] ?? '-'}"),
                      //     );
                      //   }).toList(),
                      //   // KUNCI UTAMA: Set onChanged menjadi null untuk men-disable edit
                      //   onChanged: (value)=>1,
                      //   // Validator opsional, karena user tidak bisa edit manual
                      //   validator: (val) => val == null
                      //       ? 'Rumah asal wajib diisi'
                      //       : null,
                      // ),
                      // const SizedBox(height: 16),

                      DropdownButtonFormField<int>(
                        decoration: const InputDecoration(
                          labelText: 'Rumah Asal',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.home),
                        ),
                        initialValue: _selectedRumahAsalId,
                        items: listRumahSupabase.map<DropdownMenuItem<int>>((
                          item,
                        ) {
                          return DropdownMenuItem<int>(
                            value: item['id'] as int,
                            child: Text("Blok ${item['blok_nomor'] ?? '-'}"),
                          );
                        }).toList(),
                        onChanged: (value) =>
                            setState(() => _selectedRumahAsalId = value),
                      ),
                      const SizedBox(height: 16),

                      DropdownButtonFormField<int>(
                        decoration: const InputDecoration(
                          labelText: 'Rumah Tujuan',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.home),
                        ),
                        initialValue: _selectedRumahTujuanId,
                        items: listRumahSupabase.map<DropdownMenuItem<int>>((
                          item,
                        ) {
                          return DropdownMenuItem<int>(
                            value: item['id'] as int,
                            child: Text("Blok ${item['blok_nomor'] ?? '-'}"),
                          );
                        }).toList(),
                        onChanged: (value) =>
                            setState(() => _selectedRumahTujuanId = value),
                      ),
                      const SizedBox(height: 16),

                      // 6. KETERANGAN (Optional Text)
                      TextFormField(
                        controller: _keteranganController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Keterangan Tambahan',
                          border: OutlineInputBorder(),
                          alignLabelWithHint: true,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // TOMBOL SIMPAN
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _simpanData,

                          child: const Text(
                            'SIMPAN DATA',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            // 4. DEFAULT (Menunggu Init)
            return const Center(child: Text("Memuat Form..."));
          },
        ),
      ),
    );
  }
}
