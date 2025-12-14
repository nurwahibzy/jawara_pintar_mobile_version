import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jawara_pintar_mobile_version/features/warga/domain/entities/warga.dart';
import 'package:jawara_pintar_mobile_version/features/warga/domain/entities/keluarga.dart';
import 'package:jawara_pintar_mobile_version/features/warga/presentation/bloc/warga_bloc.dart';

class WargaFormPage extends StatefulWidget {
  final Warga? warga;
  final int? keluargaId; // Optional untuk create mode

  const WargaFormPage({super.key, this.warga, this.keluargaId});

  @override
  State<WargaFormPage> createState() => _WargaFormPageState();
}

class _WargaFormPageState extends State<WargaFormPage> {
  late TextEditingController _namaController;
  late TextEditingController _nikController;
  late TextEditingController _nomorTeleponController;
  late TextEditingController _tempatLahirController;
  late TextEditingController _tanggalLahirController;
  late TextEditingController _pekerjaanController;
  late TextEditingController _keluargaSearchController;

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
  List<Keluarga> _keluargaList = [];
  bool _isLoadingKeluarga = false;

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

  bool get isEdit => widget.warga != null;

  @override
  void initState() {
    super.initState();
    final data = widget.warga;

    _namaController = TextEditingController(text: data?.nama ?? '');
    _nikController = TextEditingController(text: data?.nik ?? '');
    _nomorTeleponController = TextEditingController(
      text: data?.nomorTelepon ?? '',
    );
    _tempatLahirController = TextEditingController(
      text: data?.tempatLahir ?? '',
    );
    _pekerjaanController = TextEditingController(text: data?.pekerjaan ?? '');
    _keluargaSearchController = TextEditingController();

    // Load keluarga list
    context.read<WargaBloc>().add(LoadKeluargaEvent());

    _jenisKelamin = data?.jenisKelamin;
    _statusKeluarga = data?.statusKeluarga;
    _statusHidup = data?.statusHidup;
    _statusPenduduk = data?.statusPenduduk;
    _agama = data?.agama;
    _golonganDarah = data?.golonganDarah;
    _pendidikanTerakhir = data?.pendidikanTerakhir;
    _tanggalLahir = data?.tanggalLahir;

    if (data?.tanggalLahir != null) {
      final tgl = data!.tanggalLahir;
      _tanggalLahirController = TextEditingController(
        text: "${tgl!.day}/${tgl.month}/${tgl.year}",
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

  void _resetForm() {
    setState(() {
      _namaController.clear();
      _nikController.clear();
      _nomorTeleponController.clear();
      _tempatLahirController.clear();
      _tanggalLahirController.clear();
      _pekerjaanController.clear();
      _keluargaSearchController.clear();
      _jenisKelamin = null;
      _statusKeluarga = null;
      _statusHidup = null;
      _statusPenduduk = null;
      _agama = null;
      _golonganDarah = null;
      _pendidikanTerakhir = null;
      _tanggalLahir = null;
      _selectedKeluarga = null;
    });
  }

  void _showKeluargaSearchDialog(BuildContext context, ThemeData theme) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        List<Keluarga> searchResults = List.from(_keluargaList);
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Cari Keluarga'),
              content: SizedBox(
                width: double.maxFinite,
                height: 400,
                child: Column(
                  children: [
                    TextField(
                      controller: _keluargaSearchController,
                      decoration: InputDecoration(
                        hintText: 'Cari nomor KK...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onChanged: (query) {
                        setDialogState(() {
                          if (query.isEmpty) {
                            searchResults = List.from(_keluargaList);
                          } else {
                            searchResults = _keluargaList
                                .where(
                                  (k) => k.nomorKk.toLowerCase().contains(
                                    query.toLowerCase(),
                                  ),
                                )
                                .toList();
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: searchResults.isEmpty
                          ? const Center(child: Text('Tidak ada data'))
                          : ListView.builder(
                              itemCount: searchResults.length,
                              itemBuilder: (context, index) {
                                final keluarga = searchResults[index];
                                return ListTile(
                                  title: Text(keluarga.nomorKk),
                                  subtitle: Text(
                                    'Status: ${keluarga.statusHunian}',
                                  ),
                                  trailing: _selectedKeluarga?.id == keluarga.id
                                      ? Icon(
                                          Icons.check,
                                          color: theme.colorScheme.primary,
                                        )
                                      : null,
                                  onTap: () {
                                    setState(
                                      () => _selectedKeluarga = keluarga,
                                    );
                                    _keluargaSearchController.clear();
                                    Navigator.pop(dialogContext);
                                  },
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    _keluargaSearchController.clear();
                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Tutup'),
                ),
              ],
            );
          },
        );
      },
    );
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

      // Keluarga sekarang opsional
      final keluargaId =
          _selectedKeluarga?.id ??
          widget.keluargaId ??
          widget.warga?.keluargaId;

      final wargaData = Warga(
        idWarga: widget.warga?.idWarga ?? 0,
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
      );

      if (isEdit) {
        context.read<WargaBloc>().add(UpdateWargaEvent(wargaData));
      } else {
        context.read<WargaBloc>().add(CreateWargaEvent(wargaData));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<WargaBloc, WargaState>(
      listener: (context, state) {
        if (state is WargaLoading) {
          setState(() => _isLoading = true);
        } else if (state is KeluargaLoading) {
          setState(() => _isLoadingKeluarga = true);
        } else {
          setState(() {
            _isLoading = false;
            _isLoadingKeluarga = false;
          });
        }

        if (state is KeluargaLoaded) {
          setState(() {
            _keluargaList = state.keluargaList;
            _isLoadingKeluarga = false;
            // Set selected keluarga if editing
            if (isEdit && widget.warga?.keluargaId != null) {
              _selectedKeluarga = _keluargaList
                  .where((k) => k.id == widget.warga!.keluargaId)
                  .firstOrNull;
            }
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
        } else if (state is KeluargaError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(isEdit ? "Edit Warga" : "Tambah Warga"),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ListView(
                  children: [
                    // --- DATA PRIBADI ---
                    Text(
                      "Data Pribadi",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
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
                        enabledBorder: _inputBorder(theme.dividerColor),
                        focusedBorder: _inputBorder(theme.colorScheme.primary),
                        errorBorder: _inputBorder(Colors.red),
                        focusedErrorBorder: _inputBorder(Colors.red),
                        filled: true,
                        fillColor:
                            theme.inputDecorationTheme.fillColor ??
                            theme.cardColor,
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
                        enabledBorder: _inputBorder(theme.dividerColor),
                        focusedBorder: _inputBorder(theme.colorScheme.primary),
                        errorBorder: _inputBorder(Colors.red),
                        focusedErrorBorder: _inputBorder(Colors.red),
                        filled: true,
                        fillColor:
                            theme.inputDecorationTheme.fillColor ??
                            theme.cardColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _jenisKelamin,
                      decoration: InputDecoration(
                        labelText: "Jenis Kelamin *",
                        enabledBorder: _inputBorder(theme.dividerColor),
                        focusedBorder: _inputBorder(theme.colorScheme.primary),
                        filled: true,
                        fillColor:
                            theme.inputDecorationTheme.fillColor ??
                            theme.cardColor,
                      ),
                      items: jenisKelaminOptions
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: e == "L"
                                  ? Text('Laki-laki')
                                  : Text('Perempuan'),
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
                        enabledBorder: _inputBorder(theme.dividerColor),
                        focusedBorder: _inputBorder(theme.colorScheme.primary),
                        filled: true,
                        fillColor:
                            theme.inputDecorationTheme.fillColor ??
                            theme.cardColor,
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
                            suffixIcon: const Icon(Icons.calendar_today),
                            enabledBorder: _inputBorder(theme.dividerColor),
                            focusedBorder: _inputBorder(
                              theme.colorScheme.primary,
                            ),
                            filled: true,
                            fillColor:
                                theme.inputDecorationTheme.fillColor ??
                                theme.cardColor,
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
                        enabledBorder: _inputBorder(theme.dividerColor),
                        focusedBorder: _inputBorder(theme.colorScheme.primary),
                        errorBorder: _inputBorder(Colors.red),
                        focusedErrorBorder: _inputBorder(Colors.red),
                        filled: true,
                        fillColor:
                            theme.inputDecorationTheme.fillColor ??
                            theme.cardColor,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // --- KELUARGA ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Keluarga",
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (_selectedKeluarga != null)
                          TextButton.icon(
                            onPressed: () {
                              setState(() => _selectedKeluarga = null);
                            },
                            icon: const Icon(Icons.clear, size: 18),
                            label: const Text('Hapus Pilihan'),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Dropdown Keluarga dengan Search
                    _isLoadingKeluarga
                        ? const Center(child: CircularProgressIndicator())
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DropdownButtonFormField<Keluarga>(
                                value: _selectedKeluarga,
                                isExpanded: true,
                                decoration: InputDecoration(
                                  labelText:
                                      "Pilih Keluarga (No. KK) (Opsional)",
                                  hintText: "Pilih keluarga atau kosongkan",
                                  enabledBorder: _inputBorder(
                                    theme.dividerColor,
                                  ),
                                  focusedBorder: _inputBorder(
                                    theme.colorScheme.primary,
                                  ),
                                  filled: true,
                                  fillColor:
                                      theme.inputDecorationTheme.fillColor ??
                                      theme.cardColor,
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.search),
                                    onPressed: () => _showKeluargaSearchDialog(
                                      context,
                                      theme,
                                    ),
                                  ),
                                ),
                                items: _keluargaList.map((keluarga) {
                                  return DropdownMenuItem<Keluarga>(
                                    value: keluarga,
                                    child: Text(
                                      '${keluarga.nomorKk} (${keluarga.statusHunian})',
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  );
                                }).toList(),
                                onChanged: (val) =>
                                    setState(() => _selectedKeluarga = val),
                              ),
                              if (_selectedKeluarga == null)
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 8.0,
                                    left: 12.0,
                                  ),
                                  child: Text(
                                    'Warga akan disimpan tanpa keluarga',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: Colors.orange,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                            ],
                          ),

                    const SizedBox(height: 24),

                    // --- STATUS KEPENDUDUKAN ---
                    Text(
                      "Status Kependudukan",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _statusKeluarga,
                      decoration: InputDecoration(
                        labelText: "Status Keluarga *",
                        enabledBorder: _inputBorder(theme.dividerColor),
                        focusedBorder: _inputBorder(theme.colorScheme.primary),
                        filled: true,
                        fillColor:
                            theme.inputDecorationTheme.fillColor ??
                            theme.cardColor,
                      ),
                      items: statusKeluargaOptions
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                      onChanged: (val) => setState(() => _statusKeluarga = val),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _statusPenduduk,
                      decoration: InputDecoration(
                        labelText: "Status Penduduk",
                        enabledBorder: _inputBorder(theme.dividerColor),
                        focusedBorder: _inputBorder(theme.colorScheme.primary),
                        filled: true,
                        fillColor:
                            theme.inputDecorationTheme.fillColor ??
                            theme.cardColor,
                      ),
                      items: statusPendudukOptions
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                      onChanged: (val) => setState(() => _statusPenduduk = val),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _statusHidup,
                      decoration: InputDecoration(
                        labelText: "Status Hidup *",
                        enabledBorder: _inputBorder(theme.dividerColor),
                        focusedBorder: _inputBorder(theme.colorScheme.primary),
                        filled: true,
                        fillColor:
                            theme.inputDecorationTheme.fillColor ??
                            theme.cardColor,
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
                    Text(
                      "Data Tambahan",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _agama,
                      decoration: InputDecoration(
                        labelText: "Agama",
                        enabledBorder: _inputBorder(theme.dividerColor),
                        focusedBorder: _inputBorder(theme.colorScheme.primary),
                        filled: true,
                        fillColor:
                            theme.inputDecorationTheme.fillColor ??
                            theme.cardColor,
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
                        enabledBorder: _inputBorder(theme.dividerColor),
                        focusedBorder: _inputBorder(theme.colorScheme.primary),
                        filled: true,
                        fillColor:
                            theme.inputDecorationTheme.fillColor ??
                            theme.cardColor,
                      ),
                      items: golonganDarahOptions
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                      onChanged: (val) => setState(() => _golonganDarah = val),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _pendidikanTerakhir,
                      decoration: InputDecoration(
                        labelText: "Pendidikan Terakhir",
                        enabledBorder: _inputBorder(theme.dividerColor),
                        focusedBorder: _inputBorder(theme.colorScheme.primary),
                        filled: true,
                        fillColor:
                            theme.inputDecorationTheme.fillColor ??
                            theme.cardColor,
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
                        enabledBorder: _inputBorder(theme.dividerColor),
                        focusedBorder: _inputBorder(theme.colorScheme.primary),
                        filled: true,
                        fillColor:
                            theme.inputDecorationTheme.fillColor ??
                            theme.cardColor,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // --- TOMBOL AKSI ---
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _submitForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.primary,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: Text(
                              isEdit ? "Perbarui" : "Simpan",
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: theme.colorScheme.onPrimary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _resetForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.secondary,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: Text(
                              "Reset",
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: theme.colorScheme.onSecondary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
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
}
