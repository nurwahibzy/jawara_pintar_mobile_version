import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jawara_pintar_mobile_version/core/theme/app_colors.dart';
import 'package:jawara_pintar_mobile_version/features/warga/domain/entities/warga.dart';
import 'package:jawara_pintar_mobile_version/features/warga/domain/entities/keluarga.dart';
import 'package:jawara_pintar_mobile_version/features/warga/presentation/bloc/warga_bloc.dart';

class EditWargaPage extends StatefulWidget {
  final Warga warga;

  const EditWargaPage({super.key, required this.warga});

  @override
  State<EditWargaPage> createState() => _EditWargaPageState();
}

class _EditWargaPageState extends State<EditWargaPage> {
  late TextEditingController _namaController;
  late TextEditingController _nikController;
  late TextEditingController _nomorTeleponController;
  late TextEditingController _tempatLahirController;
  late TextEditingController _tanggalLahirController;
  late TextEditingController _pekerjaanController;
  late TextEditingController _keluargaSearchController;
  late TextEditingController _keluargaNomorKkController;

  String? _jenisKelamin;
  String? _statusKeluarga;
  String? _statusHidup;
  String? _statusPenduduk;
  String? _agama;
  String? _golonganDarah;
  String? _pendidikanTerakhir;
  DateTime? _tanggalLahir;

  // Keluarga selection
  Keluarga? _selectedKeluarga;
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  // Enum values dari database
  static const List<String> jenisKelaminOptions = ['L', 'P'];
  static const List<String> agamaOptions = [
    'Islam',
    'Kristen Protestan',
    'Katolik',
    'Hindu',
    'Buddha',
    'Konghucu',
    'Lainnya',
  ];
  static const List<String> golonganDarahOptions = [
    'A+',
    'A',
    'B+',
    'B',
    'AB+',
    'AB',
    'O+',
    'O',
    '',
  ];
  static const List<String> statusKeluargaOptions = [
    'Kepala Keluarga',
    'Istri',
    'Anak',
    'Famili Lain',
  ];
  static const List<String> pendidikanTerakhirOptions = [
    "Tidak/Belum Sekolah",
    "Belum Tamat SD",
    "Tamat SD/Sederajat",
    "SLTP/Sederajat",
    "SLTA/Sederajat",
    "Diploma I/II",
    "Akademi/Diploma III/Sarjana Muda",
    "Diploma IV/Strata I",
    "Strata II",
    "Strata III",
  ];
  static const List<String> statusPendudukOptions = ['Aktif', 'Nonaktif'];
  static const List<String> statusHidupOptions = ['Hidup', 'Meninggal'];

  @override
  void initState() {
    super.initState();
    final data = widget.warga;

    _namaController = TextEditingController(text: data.nama);
    _nikController = TextEditingController(text: data.nik);
    _nomorTeleponController = TextEditingController(text: data.nomorTelepon);
    _tempatLahirController = TextEditingController(
      text: data.tempatLahir ?? '',
    );
    _pekerjaanController = TextEditingController(text: data.pekerjaan ?? '');
    _keluargaSearchController = TextEditingController();
    _keluargaNomorKkController = TextEditingController(text: 'Memuat...');

    // Load keluarga list
    context.read<WargaBloc>().add(LoadKeluargaEvent());

    // Validasi nilai dropdown - pastikan ada di options, jika tidak set null
    _jenisKelamin = jenisKelaminOptions.contains(data.jenisKelamin)
        ? data.jenisKelamin
        : null;
    _statusKeluarga = statusKeluargaOptions.contains(data.statusKeluarga)
        ? data.statusKeluarga
        : null;
    _statusHidup = statusHidupOptions.contains(data.statusHidup)
        ? data.statusHidup
        : null;
    _statusPenduduk = statusPendudukOptions.contains(data.statusPenduduk)
        ? data.statusPenduduk
        : null;
    _agama = agamaOptions.contains(data.agama) ? data.agama : null;
    _golonganDarah = golonganDarahOptions.contains(data.golonganDarah)
        ? data.golonganDarah
        : null;
    _pendidikanTerakhir =
        pendidikanTerakhirOptions.contains(data.pendidikanTerakhir)
        ? data.pendidikanTerakhir
        : null;
    _tanggalLahir = data.tanggalLahir;

    if (data.tanggalLahir != null) {
      final tgl = data.tanggalLahir!;
      _tanggalLahirController = TextEditingController(
        text: "${tgl.day}/${tgl.month}/${tgl.year}",
      );
    } else {
      _tanggalLahirController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _nikController.dispose();
    _nomorTeleponController.dispose();
    _tempatLahirController.dispose();
    _tanggalLahirController.dispose();
    _pekerjaanController.dispose();
    _keluargaSearchController.dispose();
    _keluargaNomorKkController.dispose();
    super.dispose();
  }

  OutlineInputBorder _inputBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: color, width: 1.5),
    );
  }

  Future<void> _pickTanggal() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _tanggalLahir ?? DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _tanggalLahir = picked;
        _tanggalLahirController.text =
            "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Validasi field required
      if (_jenisKelamin == null ||
          _statusKeluarga == null ||
          _statusHidup == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mohon lengkapi data yang wajib diisi')),
        );
        return;
      }

      final keluargaId = _selectedKeluarga?.id ?? widget.warga.keluargaId;

      final wargaData = Warga(
        idWarga: widget.warga.idWarga,
        keluargaId: keluargaId,
        nik: _nikController.text.trim(),
        nama: _namaController.text.trim(),
        nomorTelepon: _nomorTeleponController.text.trim(),
        tempatLahir: _tempatLahirController.text.trim().isEmpty
            ? null
            : _tempatLahirController.text.trim(),
        tanggalLahir: _tanggalLahir,
        jenisKelamin: _jenisKelamin!,
        statusKeluarga: _statusKeluarga!,
        statusHidup: _statusHidup!,
        agama: _agama,
        golonganDarah: _golonganDarah,
        pendidikanTerakhir: _pendidikanTerakhir,
        pekerjaan: _pekerjaanController.text.trim().isEmpty
            ? null
            : _pekerjaanController.text.trim(),
        statusPenduduk: _statusPenduduk,
        createdAt: widget.warga.createdAt,
        updatedAt: DateTime.now(),
      );

      context.read<WargaBloc>().add(UpdateWargaEvent(wargaData));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<WargaBloc, WargaState>(
      listener: (context, state) {
        if (state is WargaLoading) {
          setState(() => _isLoading = true);
        } else {
          setState(() => _isLoading = false);
        }

        if (state is KeluargaLoaded) {
          setState(() {
            // Set selected keluarga based on current warga's keluargaId
            _selectedKeluarga = state.keluargaList
                .where((k) => k.id == widget.warga.keluargaId)
                .firstOrNull;
            // Update nomor KK controller
            _keluargaNomorKkController.text = _selectedKeluarga?.nomorKk ?? '-';
          });
        } else if (state is WargaActionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true);
        } else if (state is WargaError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text(
            "Edit Data Warga",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- DATA PRIBADI ---
                    _buildSectionHeader('Data Pribadi', Icons.person),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _namaController,
                      cursorColor: theme.colorScheme.primary,
                      style: theme.textTheme.bodyMedium,
                      validator: (value) =>
                          value?.isEmpty == true ? 'Nama wajib diisi' : null,
                      decoration: InputDecoration(
                        labelText: "Nama Lengkap *",
                        hintText: "Masukkan nama lengkap",
                        prefixIcon: const Icon(Icons.person_outline),
                        enabledBorder: _inputBorder(theme.dividerColor),
                        focusedBorder: _inputBorder(theme.colorScheme.primary),
                        errorBorder: _inputBorder(Colors.red),
                        focusedErrorBorder: _inputBorder(Colors.red),
                        filled: true,
                        fillColor: AppColors.secondBackground,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _nikController,
                      cursorColor: theme.colorScheme.primary,
                      style: theme.textTheme.bodyMedium,
                      validator: (value) =>
                          value?.isEmpty == true ? 'NIK wajib diisi' : null,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "NIK *",
                        hintText: "Masukkan NIK",
                        prefixIcon: const Icon(Icons.credit_card),
                        enabledBorder: _inputBorder(theme.dividerColor),
                        focusedBorder: _inputBorder(theme.colorScheme.primary),
                        errorBorder: _inputBorder(Colors.red),
                        focusedErrorBorder: _inputBorder(Colors.red),
                        filled: true,
                        fillColor: AppColors.secondBackground,
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _jenisKelamin,
                      decoration: InputDecoration(
                        labelText: "Jenis Kelamin *",
                        prefixIcon: const Icon(Icons.wc),
                        enabledBorder: _inputBorder(theme.dividerColor),
                        focusedBorder: _inputBorder(theme.colorScheme.primary),
                        filled: true,
                        fillColor: AppColors.secondBackground,
                      ),
                      items: jenisKelaminOptions
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(e == "L" ? 'Laki-laki' : 'Perempuan'),
                            ),
                          )
                          .toList(),
                      onChanged: (val) => setState(() => _jenisKelamin = val),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _tempatLahirController,
                      cursorColor: theme.colorScheme.primary,
                      style: theme.textTheme.bodyMedium,
                      decoration: InputDecoration(
                        labelText: "Tempat Lahir",
                        hintText: "Masukkan tempat lahir",
                        prefixIcon: const Icon(Icons.location_city),
                        enabledBorder: _inputBorder(theme.dividerColor),
                        focusedBorder: _inputBorder(theme.colorScheme.primary),
                        filled: true,
                        fillColor: AppColors.secondBackground,
                      ),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: _pickTanggal,
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: _tanggalLahirController,
                          cursorColor: theme.colorScheme.primary,
                          style: theme.textTheme.bodyMedium,
                          decoration: InputDecoration(
                            labelText: "Tanggal Lahir",
                            hintText: "Pilih tanggal lahir",
                            prefixIcon: const Icon(Icons.cake),
                            suffixIcon: const Icon(Icons.calendar_today),
                            enabledBorder: _inputBorder(theme.dividerColor),
                            focusedBorder: _inputBorder(
                              theme.colorScheme.primary,
                            ),
                            filled: true,
                            fillColor: AppColors.secondBackground,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _nomorTeleponController,
                      cursorColor: theme.colorScheme.primary,
                      style: theme.textTheme.bodyMedium,
                      validator: (value) => value?.isEmpty == true
                          ? 'Nomor telepon wajib diisi'
                          : null,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: "Nomor Telepon *",
                        hintText: "Masukkan nomor telepon",
                        prefixIcon: const Icon(Icons.phone),
                        enabledBorder: _inputBorder(theme.dividerColor),
                        focusedBorder: _inputBorder(theme.colorScheme.primary),
                        errorBorder: _inputBorder(Colors.red),
                        focusedErrorBorder: _inputBorder(Colors.red),
                        filled: true,
                        fillColor: AppColors.secondBackground,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // --- KELUARGA ---
                    _buildSectionHeader('Data Keluarga', Icons.family_restroom),
                    const SizedBox(height: 12),
                    // Keluarga - Disabled (tidak bisa diubah)
                    TextFormField(
                      controller: _keluargaNomorKkController,
                      enabled: false,
                      style: TextStyle(color: Colors.grey[700]),
                      decoration: InputDecoration(
                        labelText: "Keluarga (No. KK)",
                        prefixIcon: Icon(Icons.home, color: Colors.grey[500]),
                        disabledBorder: _inputBorder(Colors.grey[300]!),
                        filled: true,
                        fillColor: Colors.grey[200],
                        helperText: "Data keluarga tidak dapat diubah",
                        helperStyle: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 11,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // --- STATUS KEPENDUDUKAN ---
                    _buildSectionHeader(
                      'Status Kependudukan',
                      Icons.how_to_reg,
                    ),
                    const SizedBox(height: 12),
                    // Status Keluarga - Disabled (tidak bisa diubah)
                    TextFormField(
                      initialValue: _statusKeluarga ?? '-',
                      enabled: false,
                      style: TextStyle(color: Colors.grey[700]),
                      decoration: InputDecoration(
                        labelText: "Status Keluarga",
                        prefixIcon: Icon(Icons.group, color: Colors.grey[500]),
                        disabledBorder: _inputBorder(Colors.grey[300]!),
                        filled: true,
                        fillColor: Colors.grey[200],
                        helperText: "Status keluarga tidak dapat diubah",
                        helperStyle: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 11,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Status Penduduk - Disabled (tidak bisa diubah)
                    TextFormField(
                      initialValue: _statusPenduduk ?? '-',
                      enabled: false,
                      style: TextStyle(color: Colors.grey[700]),
                      decoration: InputDecoration(
                        labelText: "Status Penduduk",
                        prefixIcon: Icon(
                          Icons.location_on,
                          color: Colors.grey[500],
                        ),
                        disabledBorder: _inputBorder(Colors.grey[300]!),
                        filled: true,
                        fillColor: Colors.grey[200],
                        helperText: "Status penduduk tidak dapat diubah",
                        helperStyle: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 11,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _statusHidup,
                      decoration: InputDecoration(
                        labelText: "Status Hidup *",
                        prefixIcon: const Icon(Icons.favorite),
                        enabledBorder: _inputBorder(theme.dividerColor),
                        focusedBorder: _inputBorder(theme.colorScheme.primary),
                        filled: true,
                        fillColor: AppColors.secondBackground,
                      ),
                      items: statusHidupOptions
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                      onChanged: (val) => setState(() => _statusHidup = val),
                    ),

                    const SizedBox(height: 24),

                    // --- DATA TAMBAHAN ---
                    _buildSectionHeader('Data Tambahan', Icons.info_outline),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _agama,
                      decoration: InputDecoration(
                        labelText: "Agama",
                        prefixIcon: const Icon(Icons.church),
                        enabledBorder: _inputBorder(theme.dividerColor),
                        focusedBorder: _inputBorder(theme.colorScheme.primary),
                        filled: true,
                        fillColor: AppColors.secondBackground,
                      ),
                      items: agamaOptions
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                      onChanged: (val) => setState(() => _agama = val),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _golonganDarah,
                      decoration: InputDecoration(
                        labelText: "Golongan Darah",
                        prefixIcon: const Icon(Icons.bloodtype),
                        enabledBorder: _inputBorder(theme.dividerColor),
                        focusedBorder: _inputBorder(theme.colorScheme.primary),
                        filled: true,
                        fillColor: AppColors.secondBackground,
                      ),
                      items: golonganDarahOptions
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(e.isEmpty ? '-' : e),
                            ),
                          )
                          .toList(),
                      onChanged: (val) => setState(() => _golonganDarah = val),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _pendidikanTerakhir,
                      decoration: InputDecoration(
                        labelText: "Pendidikan Terakhir",
                        prefixIcon: const Icon(Icons.school),
                        enabledBorder: _inputBorder(theme.dividerColor),
                        focusedBorder: _inputBorder(theme.colorScheme.primary),
                        filled: true,
                        fillColor: AppColors.secondBackground,
                      ),
                      items: pendidikanTerakhirOptions
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                      onChanged: (val) =>
                          setState(() => _pendidikanTerakhir = val),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _pekerjaanController,
                      cursorColor: theme.colorScheme.primary,
                      style: theme.textTheme.bodyMedium,
                      decoration: InputDecoration(
                        labelText: "Pekerjaan",
                        hintText: "Masukkan pekerjaan",
                        prefixIcon: const Icon(Icons.work),
                        enabledBorder: _inputBorder(theme.dividerColor),
                        focusedBorder: _inputBorder(theme.colorScheme.primary),
                        filled: true,
                        fillColor: AppColors.secondBackground,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // --- TOMBOL AKSI ---
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _isLoading ? null : _submitForm,
                            icon: _isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(Icons.save),
                            label: Text(_isLoading ? "Menyimpan..." : "Simpan"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _isLoading
                                ? null
                                : () => Navigator.pop(context),
                            icon: const Icon(Icons.close),
                            label: const Text("Batal"),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.grey[700],
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              side: BorderSide(color: Colors.grey[400]!),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            // Loading overlay
            if (_isLoading)
              Container(
                color: Colors.black26,
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
