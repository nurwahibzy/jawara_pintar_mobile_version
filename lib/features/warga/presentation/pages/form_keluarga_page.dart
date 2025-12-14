import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jawara_pintar_mobile_version/core/theme/app_colors.dart';
import 'package:jawara_pintar_mobile_version/features/warga/domain/entities/keluarga.dart';
import 'package:jawara_pintar_mobile_version/features/warga/presentation/bloc/warga_bloc.dart';

class FormKeluargaPage extends StatefulWidget {
  final Keluarga? keluarga;

  const FormKeluargaPage({super.key, this.keluarga});

  @override
  State<FormKeluargaPage> createState() => _FormKeluargaPageState();
}

class _FormKeluargaPageState extends State<FormKeluargaPage> {
  late TextEditingController _nomorKkController;
  late TextEditingController _tanggalTerdaftarController;
  late TextEditingController _rumahSearchController;

  String? _statusHunian;
  DateTime? _tanggalTerdaftar;

  // Rumah selection
  int? _selectedRumahId;
  String? _selectedRumahAlamat;
  List<Map<String, dynamic>> _rumahList = [];
  bool _isLoadingRumah = false;
  bool _isLoading = false;

  // Anggota selection
  List<int> _selectedWargaIds = [];
  List<dynamic> _wargaTanpaKeluargaList = [];
  bool _isLoadingWarga = false;

  final _formKey = GlobalKey<FormState>();

  static const List<String> statusHunianOptions = [
    'Aktif',
    'Pindah Internal',
    'Keluar Wilayah',
  ];

  bool get isEdit => widget.keluarga != null;

  @override
  void initState() {
    super.initState();
    final data = widget.keluarga;

    _nomorKkController = TextEditingController(text: data?.nomorKk ?? '');
    _rumahSearchController = TextEditingController();

    _statusHunian = data?.statusHunian ?? 'Aktif';
    _tanggalTerdaftar = data?.tanggalTerdaftar;
    _selectedRumahId = data?.rumahId;
    _selectedRumahAlamat = data?.rumah?.alamat;

    if (data?.tanggalTerdaftar != null) {
      final tgl = data!.tanggalTerdaftar!;
      _tanggalTerdaftarController = TextEditingController(
        text: "${tgl.day}/${tgl.month}/${tgl.year}",
      );
    } else {
      _tanggalTerdaftarController = TextEditingController();
    }

    // Load rumah list and warga tanpa keluarga
    context.read<WargaBloc>().add(LoadRumahEvent());
    if (!isEdit) {
      context.read<WargaBloc>().add(LoadWargaTanpaKeluargaEvent());
    }
  }

  @override
  void dispose() {
    _nomorKkController.dispose();
    _tanggalTerdaftarController.dispose();
    _rumahSearchController.dispose();
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
      initialDate: _tanggalTerdaftar ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _tanggalTerdaftar = picked;
        _tanggalTerdaftarController.text =
            "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  void _showRumahSearchDialog(BuildContext context, ThemeData theme) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        List<Map<String, dynamic>> searchResults = List.from(_rumahList);
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Cari Rumah'),
              content: SizedBox(
                width: double.maxFinite,
                height: 400,
                child: Column(
                  children: [
                    TextField(
                      controller: _rumahSearchController,
                      decoration: InputDecoration(
                        hintText: 'Cari alamat rumah...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onChanged: (query) {
                        setDialogState(() {
                          if (query.isEmpty) {
                            searchResults = List.from(_rumahList);
                          } else {
                            searchResults = _rumahList
                                .where(
                                  (r) => (r['alamat'] as String)
                                      .toLowerCase()
                                      .contains(query.toLowerCase()),
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
                                final rumah = searchResults[index];
                                return ListTile(
                                  title: Text(rumah['alamat']),
                                  trailing: _selectedRumahId == rumah['id']
                                      ? Icon(
                                          Icons.check,
                                          color: theme.colorScheme.primary,
                                        )
                                      : null,
                                  onTap: () {
                                    setState(() {
                                      _selectedRumahId = rumah['id'];
                                      _selectedRumahAlamat = rumah['alamat'];
                                    });
                                    _rumahSearchController.clear();
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
                    _rumahSearchController.clear();
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

  void _showAnggotaSelectionDialog(BuildContext context, ThemeData theme) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        List<int> tempSelectedIds = List.from(_selectedWargaIds);
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Pilih Anggota Keluarga'),
              content: SizedBox(
                width: double.maxFinite,
                height: 400,
                child: _wargaTanpaKeluargaList.isEmpty
                    ? const Center(
                        child: Text('Tidak ada warga tanpa keluarga'),
                      )
                    : ListView.builder(
                        itemCount: _wargaTanpaKeluargaList.length,
                        itemBuilder: (context, index) {
                          final warga = _wargaTanpaKeluargaList[index];
                          final isSelected = tempSelectedIds.contains(
                            warga.idWarga,
                          );
                          return CheckboxListTile(
                            title: Text(warga.nama),
                            subtitle: Text('NIK: ${warga.nik}'),
                            value: isSelected,
                            onChanged: (bool? value) {
                              setDialogState(() {
                                if (value == true) {
                                  tempSelectedIds.add(warga.idWarga!);
                                } else {
                                  tempSelectedIds.remove(warga.idWarga);
                                }
                              });
                            },
                          );
                        },
                      ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedWargaIds = tempSelectedIds;
                    });
                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Simpan'),
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
      if (_statusHunian == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mohon pilih status hunian')),
        );
        return;
      }

      final keluargaData = Keluarga(
        id: widget.keluarga?.id ?? 0,
        nomorKk: _nomorKkController.text.trim(),
        rumahId: _selectedRumahId,
        statusHunian: _statusHunian!,
        tanggalTerdaftar: _tanggalTerdaftar,
      );

      if (isEdit) {
        context.read<WargaBloc>().add(UpdateKeluargaEvent(keluargaData));
      } else {
        context.read<WargaBloc>().add(CreateKeluargaEvent(keluargaData));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<WargaBloc, WargaState>(
      listener: (context, state) {
        if (state is KeluargaLoading) {
          setState(() => _isLoading = true);
        } else if (state is RumahLoading) {
          setState(() => _isLoadingRumah = true);
        } else {
          setState(() {
            _isLoading = false;
            _isLoadingRumah = false;
          });
        }

        if (state is RumahListLoaded) {
          setState(() {
            _rumahList = state.rumahList;
            _isLoadingRumah = false;
          });
        } else if (state is WargaTanpaKeluargaLoaded) {
          setState(() {
            _wargaTanpaKeluargaList = state.wargaList;
            _isLoadingWarga = false;
          });
        } else if (state is KeluargaActionSuccess) {
          // Jika ada warga yang dipilih, assign ke keluarga yang baru dibuat
          if (_selectedWargaIds.isNotEmpty &&
              !isEdit &&
              state.keluargaId != null) {
            context.read<WargaBloc>().add(
              AssignWargaToKeluargaEvent(_selectedWargaIds, state.keluargaId!),
            );
            return;
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true);
        } else if (state is WargaActionSuccess) {
          // Success dari assign warga
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true);
        } else if (state is KeluargaError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        } else if (state is RumahError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(isEdit ? "Edit Keluarga" : "Tambah Keluarga"),
          centerTitle: true,
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
        body: Stack(
          children: [
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ListView(
                  children: [
                    // Nomor KK
                    TextFormField(
                      controller: _nomorKkController,
                      cursorColor: theme.colorScheme.primary,
                      style: theme.textTheme.bodyMedium,
                      validator: (value) => value?.isEmpty == true
                          ? 'Nomor KK wajib diisi'
                          : null,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Nomor KK *",
                        hintText: "Masukkan nomor KK",
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
                    const SizedBox(height: 16),

                    // Status Hunian
                    DropdownButtonFormField<String>(
                      value: _statusHunian,
                      decoration: InputDecoration(
                        labelText: "Status Hunian *",
                        enabledBorder: _inputBorder(theme.dividerColor),
                        focusedBorder: _inputBorder(theme.colorScheme.primary),
                        filled: true,
                        fillColor:
                            theme.inputDecorationTheme.fillColor ??
                            theme.cardColor,
                      ),
                      items: statusHunianOptions
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                      onChanged: (val) => setState(() => _statusHunian = val),
                    ),
                    const SizedBox(height: 16),

                    // Tanggal Terdaftar
                    GestureDetector(
                      onTap: _pickTanggal,
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: _tanggalTerdaftarController,
                          cursorColor: theme.colorScheme.primary,
                          style: theme.textTheme.bodyMedium,
                          decoration: InputDecoration(
                            labelText: "Tanggal Terdaftar",
                            hintText: "Pilih tanggal terdaftar",
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
                    const SizedBox(height: 16),

                    // Rumah (Opsional)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Rumah (Opsional)",
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (_selectedRumahId != null)
                          TextButton.icon(
                            onPressed: () {
                              setState(() {
                                _selectedRumahId = null;
                                _selectedRumahAlamat = null;
                              });
                            },
                            icon: const Icon(Icons.clear, size: 18),
                            label: const Text('Hapus'),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    _isLoadingRumah
                        ? const Center(child: CircularProgressIndicator())
                        : GestureDetector(
                            onTap: () => _showRumahSearchDialog(context, theme),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                border: Border.all(color: theme.dividerColor),
                                borderRadius: BorderRadius.circular(10),
                                color:
                                    theme.inputDecorationTheme.fillColor ??
                                    theme.cardColor,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      _selectedRumahAlamat ??
                                          'Pilih rumah atau kosongkan',
                                      style: TextStyle(
                                        color: _selectedRumahAlamat == null
                                            ? Colors.grey
                                            : theme.textTheme.bodyMedium?.color,
                                      ),
                                    ),
                                  ),
                                  const Icon(Icons.search),
                                ],
                              ),
                            ),
                          ),
                    if (_selectedRumahId == null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, left: 12.0),
                        child: Text(
                          'Keluarga akan disimpan tanpa rumah',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.orange,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),

                    const SizedBox(height: 24),

                    // Anggota Keluarga (Hanya untuk create)
                    if (!isEdit) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Anggota Keluarga (Opsional)",
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () =>
                                _showAnggotaSelectionDialog(context, theme),
                            icon: const Icon(Icons.person_add, size: 18),
                            label: Text(
                              _selectedWargaIds.isEmpty ? 'Pilih' : 'Edit',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      if (_selectedWargaIds.isEmpty)
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(color: theme.dividerColor),
                            borderRadius: BorderRadius.circular(10),
                            color:
                                theme.inputDecorationTheme.fillColor ??
                                theme.cardColor,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: Colors.grey,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Belum ada anggota yang dipilih',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: theme.dividerColor),
                            borderRadius: BorderRadius.circular(10),
                            color:
                                theme.inputDecorationTheme.fillColor ??
                                theme.cardColor,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${_selectedWargaIds.length} anggota dipilih',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: _selectedWargaIds.map((id) {
                                  final warga = _wargaTanpaKeluargaList
                                      .firstWhere((w) => w.idWarga == id);
                                  return Chip(
                                    label: Text(
                                      warga.nama,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    deleteIcon: const Icon(
                                      Icons.close,
                                      size: 18,
                                    ),
                                    onDeleted: () {
                                      setState(() {
                                        _selectedWargaIds.remove(id);
                                      });
                                    },
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                    ],

                    const SizedBox(height: 32),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: _isLoading ? null : _submitForm,
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                isEdit ? 'Update' : 'Simpan',
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
          ],
        ),
      ),
    );
  }
}
