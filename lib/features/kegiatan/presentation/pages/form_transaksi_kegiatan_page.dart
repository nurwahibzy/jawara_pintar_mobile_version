import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/transaksi_kegiatan.dart';
import '../bloc/kegiatan_bloc.dart';

class FormTransaksiKegiatanPage extends StatefulWidget {
  final int kegiatanId;

  const FormTransaksiKegiatanPage({super.key, required this.kegiatanId});

  @override
  State<FormTransaksiKegiatanPage> createState() =>
      _FormTransaksiKegiatanPageState();
}

class _FormTransaksiKegiatanPageState extends State<FormTransaksiKegiatanPage> {
  final _formKey = GlobalKey<FormState>();
  final _judulController = TextEditingController();
  final _nominalController = TextEditingController();
  final _keteranganController = TextEditingController();

  List<Map<String, dynamic>> _kategoriList = [];
  int? _selectedKategoriId;
  String _selectedJenis = 'Pemasukan';
  bool _isLoadingKategori = false;

  DateTime _tanggalTransaksi = DateTime.now();
  File? _selectedImage;
  bool _isUploading = false;

  final _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadKategoriTransaksi();
  }

  Future<void> _loadKategoriTransaksi() async {
    setState(() {
      _isLoadingKategori = true;
    });

    try {
      final response = await Supabase.instance.client
          .from('kategori_transaksi')
          .select()
          .order('jenis')
          .order('nama_kategori');

      if (mounted) {
        setState(() {
          _kategoriList = List<Map<String, dynamic>>.from(response);
          _isLoadingKategori = false;

          // Set default kategori (first Pemasukan)
          final firstPemasukan = _kategoriList.firstWhere(
            (k) => k['jenis'] == 'Pemasukan',
            orElse: () => _kategoriList.first,
          );
          _selectedKategoriId = firstPemasukan['id'];
          _selectedJenis = firstPemasukan['jenis'];
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingKategori = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal memuat kategori: $e')));
      }
    }
  }

  @override
  void dispose() {
    _judulController.dispose();
    _nominalController.dispose();
    _keteranganController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal mengambil gambar: $e')));
      }
    }
  }

  Future<String?> _uploadImage() async {
    if (_selectedImage == null) return null;

    setState(() {
      _isUploading = true;
    });

    try {
      final fileName =
          'transaksi_${widget.kegiatanId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final bytes = await _selectedImage!.readAsBytes();

      await Supabase.instance.client.storage
          .from('kegiatan')
          .uploadBinary(fileName, bytes);

      final url = Supabase.instance.client.storage
          .from('kegiatan')
          .getPublicUrl(fileName);

      return url;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal upload gambar: $e')));
      }
      return null;
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _tanggalTransaksi,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      locale: const Locale('id', 'ID'),
    );
    if (picked != null && picked != _tanggalTransaksi) {
      setState(() {
        _tanggalTransaksi = picked;
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Upload image if selected
    String? imageUrl;
    if (_selectedImage != null) {
      imageUrl = await _uploadImage();
      if (imageUrl == null) {
        return; // Upload failed
      }
    }

    // Get auth user ID
    final authId = Supabase.instance.client.auth.currentUser?.id;
    if (authId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('User tidak ditemukan')));
      return;
    }

    // Get id from users table
    int? userIdFromTable;
    try {
      final userResponse = await Supabase.instance.client
          .from('users')
          .select('id')
          .eq('auth_id', authId)
          .maybeSingle();

      if (userResponse != null) {
        userIdFromTable = userResponse['id'] as int?;
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mendapatkan user info: $e')),
        );
      }
      return;
    }

    if (userIdFromTable == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('User ID tidak valid')));
      return;
    }

    if (_selectedKategoriId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih kategori transaksi terlebih dahulu'),
        ),
      );
      return;
    }

    final selectedKategori = _kategoriList.firstWhere(
      (k) => k['id'] == _selectedKategoriId,
    );

    final nominal = double.parse(_nominalController.text.replaceAll('.', ''));
    final judul = _judulController.text;
    final keterangan = _keteranganController.text.isEmpty
        ? null
        : _keteranganController.text;

    try {
      // STEP 1: Create transaksi di pemasukan_lain atau pengeluaran
      int? transaksiId;

      if (_selectedJenis == 'Pemasukan') {
        // Insert ke pemasukan_lain
        final response = await Supabase.instance.client
            .from('pemasukan_lain')
            .insert({
              'judul': judul,
              'kategori_transaksi_id': _selectedKategoriId,
              'nominal': nominal,
              'tanggal_transaksi': _tanggalTransaksi.toIso8601String(),
              'bukti_foto': imageUrl,
              'keterangan': keterangan,
              'created_by': userIdFromTable,
            })
            .select()
            .single();

        transaksiId = response['id'] as int;
      } else {
        // Insert ke pengeluaran
        final response = await Supabase.instance.client
            .from('pengeluaran')
            .insert({
              'judul': judul,
              'kategori_transaksi_id': _selectedKategoriId,
              'nominal': nominal,
              'tanggal_transaksi': _tanggalTransaksi.toIso8601String(),
              'bukti_foto': imageUrl,
              'keterangan': keterangan,
              'created_by': authId, // pengeluaran uses auth_id directly
            })
            .select()
            .single();

        transaksiId = response['id'] as int;
      }

      if (transaksiId == null) {
        throw Exception('Gagal mendapatkan ID transaksi');
      }

      // STEP 2: Link transaksi ke kegiatan di bridge table
      final transaksiKegiatan = TransaksiKegiatan(
        id: 0, // Will be auto-generated
        kegiatanId: widget.kegiatanId,
        jenisTransaksi: _selectedJenis,
        pemasukanId: _selectedJenis == 'Pemasukan' ? transaksiId : null,
        pengeluaranId: _selectedJenis == 'Pengeluaran' ? transaksiId : null,
        createdBy: userIdFromTable,
        createdAt: DateTime.now(),
      );

      context.read<KegiatanBloc>().add(
        CreateTransaksiKegiatanEvent(transaksiKegiatan),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menambah transaksi: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Transaksi')),
      body: BlocListener<KegiatanBloc, KegiatanState>(
        listener: (context, state) {
          if (state is TransaksiActionSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
            // Reload transaksi list and go back
            context.read<KegiatanBloc>().add(
              GetTransaksiKegiatanEvent(widget.kegiatanId),
            );
            Navigator.pop(context);
          } else if (state is KegiatanError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Kategori Transaksi
              if (_isLoadingKategori)
                const Center(child: CircularProgressIndicator())
              else
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Kategori Transaksi',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Filter by Jenis
                        SegmentedButton<String>(
                          segments: const [
                            ButtonSegment(
                              value: 'Pemasukan',
                              label: Text('Pemasukan'),
                              icon: Icon(Icons.arrow_downward),
                            ),
                            ButtonSegment(
                              value: 'Pengeluaran',
                              label: Text('Pengeluaran'),
                              icon: Icon(Icons.arrow_upward),
                            ),
                          ],
                          selected: {_selectedJenis},
                          onSelectionChanged: (Set<String> selected) {
                            setState(() {
                              _selectedJenis = selected.first;
                              // Reset kategori selection to first of new jenis
                              final firstOfJenis = _kategoriList.firstWhere(
                                (k) => k['jenis'] == _selectedJenis,
                                orElse: () => _kategoriList.first,
                              );
                              _selectedKategoriId = firstOfJenis['id'];
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        // Dropdown kategori
                        DropdownButtonFormField<int>(
                          value: _selectedKategoriId,
                          decoration: const InputDecoration(
                            labelText: 'Pilih Kategori',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.category),
                          ),
                          items: _kategoriList
                              .where((k) => k['jenis'] == _selectedJenis)
                              .map((kategori) {
                                return DropdownMenuItem<int>(
                                  value: kategori['id'],
                                  child: Text(kategori['nama_kategori']),
                                );
                              })
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedKategoriId = value;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Pilih kategori';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 16),

              // Judul
              TextFormField(
                controller: _judulController,
                decoration: const InputDecoration(
                  labelText: 'Judul Transaksi',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Judul tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Nominal
              TextFormField(
                controller: _nominalController,
                decoration: const InputDecoration(
                  labelText: 'Nominal (Rp)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  _ThousandsSeparatorInputFormatter(),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nominal tidak boleh kosong';
                  }
                  final nominal = double.tryParse(value.replaceAll('.', ''));
                  if (nominal == null || nominal <= 0) {
                    return 'Nominal harus lebih dari 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Tanggal Transaksi
              InkWell(
                onTap: _selectDate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Tanggal Transaksi',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(
                    DateFormat(
                      'dd MMMM yyyy',
                      'id_ID',
                    ).format(_tanggalTransaksi),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Keterangan
              TextFormField(
                controller: _keteranganController,
                decoration: const InputDecoration(
                  labelText: 'Keterangan (Opsional)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.notes),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              // Bukti Foto
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Bukti Foto (Opsional)',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (_selectedImage != null) ...[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            _selectedImage!,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: _pickImage,
                                icon: const Icon(Icons.camera_alt),
                                label: const Text('Ganti Foto'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _selectedImage = null;
                                });
                              },
                              icon: const Icon(Icons.delete),
                              color: Colors.red,
                            ),
                          ],
                        ),
                      ] else
                        ElevatedButton.icon(
                          onPressed: _pickImage,
                          icon: const Icon(Icons.camera_alt),
                          label: const Text('Ambil Foto'),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Submit Button
              BlocBuilder<KegiatanBloc, KegiatanState>(
                builder: (context, state) {
                  final isLoading = state is KegiatanLoading || _isUploading;
                  return ElevatedButton(
                    onPressed: isLoading ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      backgroundColor: _selectedJenis == 'Pemasukan'
                          ? Colors.green
                          : Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            'Simpan $_selectedJenis',
                            style: const TextStyle(fontSize: 16),
                          ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom input formatter for thousands separator
class _ThousandsSeparatorInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final number = int.tryParse(newValue.text.replaceAll('.', ''));
    if (number == null) {
      return oldValue;
    }

    final formatted = NumberFormat(
      '#,###',
      'id_ID',
    ).format(number).replaceAll(',', '.');

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
