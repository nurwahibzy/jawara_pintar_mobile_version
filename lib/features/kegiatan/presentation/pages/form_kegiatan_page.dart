import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';
import '../../domain/entities/kegiatan.dart';
import '../../data/datasources/kegiatan_remote_datasource.dart';
import '../bloc/kegiatan_bloc.dart';
import '../../../../core/theme/app_colors.dart';

class FormKegiatanPage extends StatefulWidget {
  final Kegiatan? kegiatan;

  const FormKegiatanPage({super.key, this.kegiatan});

  @override
  State<FormKegiatanPage> createState() => _FormKegiatanPageState();
}

class _FormKegiatanPageState extends State<FormKegiatanPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaKegiatanController = TextEditingController();
  final _deskripsiController = TextEditingController();
  final _lokasiController = TextEditingController();
  final _penanggungJawabController = TextEditingController();
  final dateFormatter = DateFormat('dd MMMM yyyy', 'id_ID');

  List<Map<String, dynamic>> _kategoriList = [];
  int? _selectedKategoriId;
  bool _isLoadingKategori = false;

  DateTime? _selectedDate;
  File? _selectedImage;
  String? _existingFotoUrl;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _loadKategoriKegiatan();
    if (widget.kegiatan != null) {
      _namaKegiatanController.text = widget.kegiatan!.namaKegiatan;
      _selectedKategoriId = widget.kegiatan!.kategoriKegiatanId;
      _deskripsiController.text = widget.kegiatan!.deskripsi;
      _lokasiController.text = widget.kegiatan!.lokasi;
      _penanggungJawabController.text = widget.kegiatan!.penanggungJawab;
      _selectedDate = widget.kegiatan!.tanggalPelaksanaan;
      _existingFotoUrl = widget.kegiatan!.fotoDokumentasi;
    }
  }

  Future<void> _loadKategoriKegiatan() async {
    setState(() => _isLoadingKategori = true);
    try {
      final dataSource = KegiatanRemoteDataSourceImpl(
        supabaseClient: Supabase.instance.client,
      );
      final kategori = await dataSource.getKategoriKegiatan();
      setState(() {
        _kategoriList = kategori;
        _isLoadingKategori = false;
      });
    } catch (e) {
      setState(() => _isLoadingKategori = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal load kategori: $e')));
      }
    }
  }

  @override
  void dispose() {
    _namaKegiatanController.dispose();
    _deskripsiController.dispose();
    _lokasiController.dispose();
    _penanggungJawabController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Kamera'),
              onTap: () {
                Navigator.pop(context);
                _getImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galeri'),
              onTap: () {
                Navigator.pop(context);
                _getImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedKategoriId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih kategori kegiatan'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih tanggal pelaksanaan'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isUploading = true);

    String? fotoUrl = _existingFotoUrl;

    // Upload foto jika ada
    if (_selectedImage != null) {
      try {
        final dataSource = KegiatanRemoteDataSourceImpl(
          supabaseClient: Supabase.instance.client,
        );

        final fileName =
            'kegiatan_${DateTime.now().millisecondsSinceEpoch}.jpg';
        fotoUrl = await dataSource.uploadFoto(_selectedImage!, fileName);
      } catch (e) {
        if (mounted) {
          setState(() => _isUploading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal upload foto: $e'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
      }
    }

    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) {
      if (mounted) {
        setState(() => _isUploading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User tidak terautentikasi'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    // Get id from users table
    int? createdBy;
    try {
      final response = await Supabase.instance.client
          .from('users')
          .select('id')
          .eq('auth_id', userId)
          .maybeSingle();

      if (response != null) {
        createdBy = response['id'] as int?;
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isUploading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mendapatkan data user: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    if (createdBy == null) {
      if (mounted) {
        setState(() => _isUploading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User ID tidak valid'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    final kegiatan = Kegiatan(
      id: widget.kegiatan?.id,
      namaKegiatan: _namaKegiatanController.text,
      kategoriKegiatanId: _selectedKategoriId!,
      deskripsi: _deskripsiController.text,
      tanggalPelaksanaan: _selectedDate!,
      lokasi: _lokasiController.text,
      penanggungJawab: _penanggungJawabController.text,
      fotoDokumentasi: fotoUrl,
      createdBy: createdBy,
      createdAt: widget.kegiatan?.createdAt ?? DateTime.now(),
    );

    if (widget.kegiatan == null) {
      context.read<KegiatanBloc>().add(CreateKegiatanEvent(kegiatan));
    } else {
      context.read<KegiatanBloc>().add(UpdateKegiatanEvent(kegiatan));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          widget.kegiatan == null ? 'Tambah Kegiatan' : 'Edit Kegiatan',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: BlocListener<KegiatanBloc, KegiatanState>(
        listener: (context, state) {
          if (state is KegiatanActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          } else if (state is KegiatanError) {
            setState(() => _isUploading = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is KegiatanLoading) {
            // Keep uploading state
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nama Kegiatan
                TextFormField(
                  controller: _namaKegiatanController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Kegiatan',
                    hintText: 'Masukkan nama kegiatan',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.event),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama kegiatan tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Kategori Kegiatan
                if (_isLoadingKategori)
                  const Center(child: CircularProgressIndicator())
                else
                  DropdownButtonFormField<int>(
                    value: _selectedKategoriId,
                    decoration: const InputDecoration(
                      labelText: 'Kategori Kegiatan',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.category),
                    ),
                    hint: const Text('Pilih Kategori'),
                    items: _kategoriList.map((kategori) {
                      return DropdownMenuItem<int>(
                        value: kategori['id'] as int,
                        child: Text(kategori['nama_kategori'] as String),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => _selectedKategoriId = value);
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Pilih kategori kegiatan';
                      }
                      return null;
                    },
                  ),
                const SizedBox(height: 16),

                // Deskripsi Kegiatan
                TextFormField(
                  controller: _deskripsiController,
                  decoration: const InputDecoration(
                    labelText: 'Deskripsi Kegiatan',
                    hintText: 'Masukkan deskripsi kegiatan',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.description),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Deskripsi tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _lokasiController,
                  decoration: const InputDecoration(
                    labelText: 'Lokasi',
                    hintText: 'Masukkan lokasi kegiatan',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.location_on),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lokasi tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _penanggungJawabController,
                  decoration: const InputDecoration(
                    labelText: 'Penanggung Jawab',
                    hintText: 'Masukkan nama penanggung jawab',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Penanggung jawab tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: _selectDate,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Tanggal Pelaksanaan',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                    child: Text(
                      _selectedDate != null
                          ? dateFormatter.format(_selectedDate!)
                          : 'Pilih tanggal',
                      style: TextStyle(
                        color: _selectedDate != null
                            ? Colors.black
                            : Colors.grey,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Foto Dokumentasi (Opsional)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                if (_selectedImage != null)
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          _selectedImage!,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () {
                            setState(() => _selectedImage = null);
                          },
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.black54,
                          ),
                        ),
                      ),
                    ],
                  )
                else if (_existingFotoUrl != null)
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          _existingFotoUrl!,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () {
                            setState(() => _existingFotoUrl = null);
                          },
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.black54,
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  InkWell(
                    onTap: _pickImage,
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_photo_alternate,
                              size: 48,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Tambah Foto',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isUploading ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isUploading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            widget.kegiatan == null ? 'Simpan' : 'Perbarui',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
