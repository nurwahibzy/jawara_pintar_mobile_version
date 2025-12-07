import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jawara_pintar_mobile_version/core/theme/app_colors.dart';
import 'package:jawara_pintar_mobile_version/features/kategori-tagihan/domain/entities/master_iuran.dart';
import 'package:jawara_pintar_mobile_version/features/kategori-tagihan/presentation/bloc/master_iuran_bloc.dart';
import 'package:jawara_pintar_mobile_version/features/kategori-tagihan/presentation/bloc/master_iuran_event.dart';
import 'package:jawara_pintar_mobile_version/features/kategori-tagihan/presentation/bloc/master_iuran_state.dart';

class EditKategoriTagihanPage extends StatefulWidget {
  final MasterIuran masterIuran;

  const EditKategoriTagihanPage({super.key, required this.masterIuran});

  @override
  State<EditKategoriTagihanPage> createState() =>
      _EditKategoriTagihanPageState();
}

class _EditKategoriTagihanPageState extends State<EditKategoriTagihanPage> {
  late TextEditingController _namaIuranController;
  late TextEditingController _nominalController;

  int? _selectedKategoriId;
  bool _isActive = true;
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  final List<Map<String, dynamic>> _kategoriOptions = [
    {'id': 1, 'nama': 'Iuran Bulanan'},
    {'id': 2, 'nama': 'Iuran Khusus'},
  ];

  @override
  void initState() {
    super.initState();
    final data = widget.masterIuran;
    _namaIuranController = TextEditingController(text: data.namaIuran);
    final nominalStr = data.nominalStandar.toInt().toString();
    _nominalController = TextEditingController(text: _formatNumber(nominalStr));
    _selectedKategoriId = data.kategoriIuranId;
    _isActive = data.isActive;
  }

  String _formatNumber(String value) {
    if (value.isEmpty) return value;
    final buffer = StringBuffer();
    for (int i = 0; i < value.length; i++) {
      buffer.write(value[i]);
      if (i + 1 < value.length && (value.length - i - 1) % 3 == 0) {
        buffer.write('.');
      }
    }
    return buffer.toString();
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

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_selectedKategoriId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mohon pilih kategori iuran')),
        );
        return;
      }

      final nominalString = _nominalController.text.replaceAll('.', '');
      final nominal = double.tryParse(nominalString) ?? 0;

      final masterIuranData = MasterIuran(
        id: widget.masterIuran.id,
        kategoriIuranId: _selectedKategoriId!,
        namaIuran: _namaIuranController.text.trim(),
        nominalStandar: nominal,
        isActive: _isActive,
        createdAt: widget.masterIuran.createdAt,
        updatedAt: DateTime.now(),
        kategoriIuran: widget.masterIuran.kategoriIuran,
      );

      context.read<MasterIuranBloc>().add(UpdateMasterIuranEvent(masterIuranData));
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
            SnackBar(content: Text(state.message), backgroundColor: Colors.green),
          );
          Navigator.pop(context, true);
        } else if (state is MasterIuranError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text("Edit Kategori Tagihn", style: TextStyle(fontWeight: FontWeight.bold)),
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
                    Text("Data Kategori Tagihn", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _namaIuranController,
                      validator: (v) => v?.isEmpty == true ? 'Nama Iuran wajib diisi' : null,
                      decoration: InputDecoration(
                        labelText: "Nama Iuran *",
                        hintText: "Masukkan nama iuran",
                        enabledBorder: _inputBorder(theme.dividerColor),
                        focusedBorder: _inputBorder(theme.colorScheme.primary),
                        errorBorder: _inputBorder(Colors.red),
                        focusedErrorBorder: _inputBorder(Colors.red),
                        filled: true,
                        fillColor: theme.cardColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<int>(
                      value: _selectedKategoriId,
                      decoration: InputDecoration(
                        labelText: "Kategori Iuran *",
                        enabledBorder: _inputBorder(theme.dividerColor),
                        focusedBorder: _inputBorder(theme.colorScheme.primary),
                        filled: true,
                        fillColor: theme.cardColor,
                      ),
                      items: _kategoriOptions.map((k) => DropdownMenuItem<int>(value: k['id'] as int, child: Text(k['nama'] as String))).toList(),
                      onChanged: (v) => setState(() => _selectedKategoriId = v),
                      validator: (v) => v == null ? 'Kategori wajib dipilih' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _nominalController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly, _ThousandsSeparatorInputFormatter()],
                      validator: (v) {
                        if (v?.isEmpty == true) return 'Nominal wajib diisi';
                        final n = double.tryParse(v!.replaceAll('.', ''));
                        if (n == null || n <= 0) return 'Nominal harus > 0';
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: "Nominal Standar *",
                        prefixText: "Rp ",
                        enabledBorder: _inputBorder(theme.dividerColor),
                        focusedBorder: _inputBorder(theme.colorScheme.primary),
                        filled: true,
                        fillColor: theme.cardColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      child: SwitchListTile(
                        title: const Text("Status Aktif"),
                        subtitle: Text(_isActive ? "Iuran aktif" : "Iuran tidak aktif"),
                        value: _isActive,
                        onChanged: (v) => setState(() => _isActive = v),
                        activeColor: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text("Simpan Perubahan", style: theme.textTheme.labelLarge?.copyWith(color: Colors.white)),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            if (_isLoading) Container(color: Colors.black26, child: const Center(child: CircularProgressIndicator())),
          ],
        ),
      ),
    );
  }
}

class _ThousandsSeparatorInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) return newValue;
    final text = newValue.text.replaceAll('.', '');
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if (i + 1 < text.length && (text.length - i - 1) % 3 == 0) buffer.write('.');
    }
    return TextEditingValue(text: buffer.toString(), selection: TextSelection.collapsed(offset: buffer.length));
  }
}
