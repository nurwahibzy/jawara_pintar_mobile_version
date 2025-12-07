import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jawara_pintar_mobile_version/core/theme/app_colors.dart';
import 'package:jawara_pintar_mobile_version/features/kategori-tagihan/domain/entities/master_iuran.dart';
import 'package:jawara_pintar_mobile_version/features/kategori-tagihan/presentation/bloc/master_iuran_bloc.dart';
import 'package:jawara_pintar_mobile_version/features/kategori-tagihan/presentation/bloc/master_iuran_event.dart';
import 'package:jawara_pintar_mobile_version/features/kategori-tagihan/presentation/bloc/master_iuran_state.dart';

class TambahKategoriTagihanPage extends StatefulWidget {
  const TambahKategoriTagihanPage({super.key});

  @override
  State<TambahKategoriTagihanPage> createState() =>
      _TambahKategoriTagihanPageState();
}

class _TambahKategoriTagihanPageState extends State<TambahKategoriTagihanPage> {
  late TextEditingController _namaIuranController;
  late TextEditingController _nominalController;

  int? _selectedKategoriId;
  bool _isActive = true;
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  // List kategori - hardcoded untuk sementara
  // TODO: Bisa diganti dengan fetch dari API kategori_iuran
  final List<Map<String, dynamic>> _kategoriOptions = [
    {'id': 1, 'nama': 'Iuran Bulanan'},
    {'id': 2, 'nama': 'Iuran Khusus'},
  ];

  @override
  void initState() {
    super.initState();
    _namaIuranController = TextEditingController();
    _nominalController = TextEditingController();
  }

  @override
  void dispose() {
    _namaIuranController.dispose();
    _nominalController.dispose();
    super.dispose();
  }

  OutlineInputBorder _inputBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: color, width: 1.5),
    );
  }

  void _resetForm() {
    setState(() {
      _namaIuranController.clear();
      _nominalController.clear();
      _selectedKategoriId = null;
      _isActive = true;
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_selectedKategoriId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mohon pilih kategori iuran')),
        );
        return;
      }

      // Parse nominal
      final nominalString = _nominalController.text.replaceAll('.', '');
      final nominal = double.tryParse(nominalString) ?? 0;

      final masterIuranData = MasterIuran(
        id: 0,
        kategoriIuranId: _selectedKategoriId!,
        namaIuran: _namaIuranController.text.trim(),
        nominalStandar: nominal,
        isActive: _isActive,
      );

      context.read<MasterIuranBloc>().add(
        CreateMasterIuranEvent(masterIuranData),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<MasterIuranBloc, MasterIuranState>(
      listener: (context, state) {
        if (state is MasterIuranLoading) {
          setState(() => _isLoading = true);
        } else {
          setState(() => _isLoading = false);
        }

        if (state is MasterIuranActionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true);
        } else if (state is MasterIuranError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Tambah Kategori Tagihan"),
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
                    // --- DATA MASTER IURAN ---
                    Text(
                      "Data Kategori Tagihan",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Nama Iuran
                    TextFormField(
                      controller: _namaIuranController,
                      cursorColor: theme.colorScheme.primary,
                      style: theme.textTheme.bodyMedium,
                      validator: (value) => value?.isEmpty == true
                          ? 'Nama Iuran wajib diisi'
                          : null,
                      decoration: InputDecoration(
                        labelText: "Nama Iuran *",
                        hintText: "Masukkan nama iuran",
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

                    // Kategori Iuran Dropdown
                    DropdownButtonFormField<int>(
                      value: _selectedKategoriId,
                      decoration: InputDecoration(
                        labelText: "Kategori Iuran *",
                        hintText: "Pilih kategori iuran",
                        enabledBorder: _inputBorder(theme.dividerColor),
                        focusedBorder: _inputBorder(theme.colorScheme.primary),
                        errorBorder: _inputBorder(Colors.red),
                        focusedErrorBorder: _inputBorder(Colors.red),
                        filled: true,
                        fillColor:
                            theme.inputDecorationTheme.fillColor ??
                            theme.cardColor,
                      ),
                      items: _kategoriOptions
                          .map(
                            (kategori) => DropdownMenuItem<int>(
                              value: kategori['id'] as int,
                              child: Text(kategori['nama'] as String),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedKategoriId = value;
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Kategori wajib dipilih' : null,
                    ),
                    const SizedBox(height: 16),

                    // Nominal Standar
                    TextFormField(
                      controller: _nominalController,
                      cursorColor: theme.colorScheme.primary,
                      style: theme.textTheme.bodyMedium,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        _ThousandsSeparatorInputFormatter(),
                      ],
                      validator: (value) {
                        if (value?.isEmpty == true) {
                          return 'Nominal Standar wajib diisi';
                        }
                        final nominalString = value!.replaceAll('.', '');
                        final nominal = double.tryParse(nominalString);
                        if (nominal == null || nominal <= 0) {
                          return 'Nominal harus lebih besar dari 0';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: "Nominal Standar *",
                        hintText: "Masukkan nominal standar",
                        prefixText: "Rp ",
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

                    // Status Aktif Switch
                    Card(
                      child: SwitchListTile(
                        title: const Text("Status Aktif"),
                        subtitle: Text(
                          _isActive
                              ? "Iuran ini aktif dan dapat digunakan"
                              : "Iuran ini tidak aktif",
                        ),
                        value: _isActive,
                        onChanged: (value) {
                          setState(() {
                            _isActive = value;
                          });
                        },
                        activeColor: theme.colorScheme.primary,
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
                              "Simpan",
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

// Helper class untuk format ribuan
class _ThousandsSeparatorInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final String newText = newValue.text.replaceAll('.', '');
    final StringBuffer buffer = StringBuffer();
    final int length = newText.length;

    for (int i = 0; i < length; i++) {
      buffer.write(newText[i]);
      final int nonZeroIndex = i + 1;
      if (nonZeroIndex < length && (length - nonZeroIndex) % 3 == 0) {
        buffer.write('.');
      }
    }

    final String formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
