import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jawara_pintar_mobile_version/features/pesan-warga/data/models/pesan_warga_model.dart';
import '../../../../core/theme/app_colors.dart';
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
  String? role; 
  int? userId;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    final bloc = context.read<AspirasiBloc>();
    role = bloc.currentRole; 
    userId = bloc.currentUserId;

    _judulController = TextEditingController(text: widget.pesan.judul);
    _deskripsiController = TextEditingController(text: widget.pesan.deskripsi);
    _tanggapanController = TextEditingController(
      text: widget.pesan.tanggapanAdmin ?? '',
    );
    _selectedStatus = widget.pesan.status;
  }

  @override
  Widget build(BuildContext context) {
    final bool isAdmin = role == "Admin";
    final bool isWarga = role == "Warga";

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Nama Warga: ${widget.pesan.namaWarga}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10),

              _buildTextField(
                "Judul",
                _judulController,
                readOnly: !(isWarga), 
              ),
              const SizedBox(height: 14),

              _buildTextField(
                "Deskripsi",
                _deskripsiController,
                readOnly: !(isWarga), 
                maxLines: 3,
              ),
              const SizedBox(height: 14),

              // --------------------- Tampil hanya jika role ADMIN ------------------------
              if (isAdmin) ...[
               _buildDropdown(
                  label: "Status",
                  value: _selectedStatus,
                  items: StatusAspirasi.values.map((s) {
                    return DropdownMenuItem(
                      value: s,
                      enabled:s !=StatusAspirasi.Pending, 
                      child: Text(
                        s.name.toUpperCase(),
                        style: TextStyle(
                          color: s == StatusAspirasi.Pending
                              ? Colors.grey
                              : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (v) {
                    if (v != StatusAspirasi.Pending) {
                      setState(() => _selectedStatus = v!);
                    }
                  },
                ),
                const SizedBox(height: 14),

                _buildTextField(
                  "Tanggapan Admin",
                  _tanggapanController,
                  maxLines: 3,
                  validator: (value) {
                    if (isAdmin && (value == null || value.isEmpty)) {
                      return "Tanggapan admin wajib diisi";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
              ],

              // ----------------------------------------------------------------------
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
                            status: isAdmin ? _selectedStatus: widget.pesan.status,
                            tanggapanAdmin: isAdmin ? _tanggapanController.text : null,
                            createdAt: widget.pesan.createdAt,
                            namaWarga: widget.pesan.namaWarga,
                            namaAdmin: isAdmin ? "Admin" : null,
                          );

                          context.read<AspirasiBloc>().add(
                            UpdateAspirasi(updatedPesan),
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Aspirasi berhasil diperbarui"),
                            ),
                          );

                          Navigator.pop(context, updatedPesan);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                      ),
                      child: const Text(
                        "Simpan",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                      ),
                      child: const Text(
                        "Batal",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
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
        DropdownButtonFormField(
          value: value,
          items: items,
          onChanged: onChanged,
        ),
      ],
    );
  }
}