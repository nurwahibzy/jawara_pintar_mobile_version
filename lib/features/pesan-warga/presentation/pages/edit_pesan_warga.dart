import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/models/pesan_warga_model.dart';
import '../../domain/entities/pesan_warga.dart';
import '../bloc/pesan_warga_bloc.dart';

class EditPesanWarga extends StatefulWidget {
  final Aspirasi pesan;
  const EditPesanWarga({super.key, required this.pesan});

  @override
  State<EditPesanWarga> createState() => _EditPesanWargaState();
}

class _EditPesanWargaState extends State<EditPesanWarga> {
  late TextEditingController _judulController;
  late TextEditingController _deskripsiController;
  late TextEditingController _tanggapanController;
  late StatusAspirasi _selectedStatus;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _judulController = TextEditingController(text: widget.pesan.judul);
    _deskripsiController = TextEditingController(text: widget.pesan.deskripsi);
    _tanggapanController = TextEditingController(
      text: widget.pesan.tanggapanAdmin ?? '',
    );
    _selectedStatus = widget.pesan.status;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondBackground,
      appBar: AppBar(
        title: const Text(
          "Edit Aspirasi",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField("Judul", _judulController, readOnly: true),
                const SizedBox(height: 14),
                _buildTextField(
                  "Deskripsi",
                  _deskripsiController,
                  readOnly: true,
                ),
                const SizedBox(height: 14),
                _buildDropdown(
                  label: "Status",
                  value: _selectedStatus,
                  items: StatusAspirasi.values.map((s) {
                    return DropdownMenuItem(
                      value: s,
                      enabled: s != StatusAspirasi.Pending,
                      child: Text(
                        s.name.toUpperCase(),
                        style: TextStyle(
                          color: s == StatusAspirasi.Pending
                              ? Colors.grey
                              : Colors.black,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val == StatusAspirasi.Pending) return;
                    setState(() => _selectedStatus = val!);
                  },
                ),
                const SizedBox(height: 14),
                _buildTextField(
                  "Tanggapan Admin",
                  _tanggapanController,
                  readOnly: false,
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Tanggapan admin wajib diisi";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final updatedPesan = Aspirasi(
                              id: widget.pesan.id,
                              wargaId: widget.pesan.wargaId,
                              judul: _judulController.text,
                              deskripsi: _deskripsiController.text,
                              status: _selectedStatus,
                              tanggapanAdmin: _tanggapanController.text,
                              updatedBy: 1, //TODO:ganti dengan id admin yg login 
                              createdAt: widget.pesan.createdAt,
                            );

                            context.read<AspirasiBloc>().add(
                              UpdateAspirasi(updatedPesan),
                            );

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Aspirasi berhasil diperbarui!'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                            Navigator.pop(context, updatedPesan);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Simpan",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Batal",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool readOnly = false,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          readOnly: readOnly,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            filled: true,
            fillColor: readOnly ? Colors.grey[200] : Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required StatusAspirasi value,
    required List<DropdownMenuItem<StatusAspirasi>> items,
    required ValueChanged<StatusAspirasi?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        DropdownButtonFormField<StatusAspirasi>(
          value: value,
          items: items,
          onChanged: onChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}