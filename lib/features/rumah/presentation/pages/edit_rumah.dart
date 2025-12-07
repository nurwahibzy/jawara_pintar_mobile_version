import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jawara_pintar_mobile_version/core/theme/app_colors.dart';
import 'package:jawara_pintar_mobile_version/features/rumah/domain/entities/rumah.dart';
import 'package:jawara_pintar_mobile_version/features/rumah/presentation/bloc/rumah_bloc.dart';

class EditRumahPage extends StatefulWidget {
  final Rumah rumah;

  const EditRumahPage({super.key, required this.rumah});

  @override
  State<EditRumahPage> createState() => _EditRumahPageState();
}

class _EditRumahPageState extends State<EditRumahPage> {
  late TextEditingController _alamatController;

  String? _statusRumah;
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  // Enum values dari database
  static const List<String> statusRumahOptions = [
    'Kosong',
    'Dihuni',
    'Disewakan',
  ];

  @override
  void initState() {
    super.initState();
    final data = widget.rumah;

    _alamatController = TextEditingController(text: data.alamat);

    // Validasi nilai dropdown - pastikan ada di options, jika tidak set null
    _statusRumah = statusRumahOptions.contains(data.statusRumah)
        ? data.statusRumah
        : null;
  }

  @override
  void dispose() {
    _alamatController.dispose();
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
      // Validasi field required
      if (_statusRumah == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mohon pilih status rumah')),
        );
        return;
      }

      final rumahData = Rumah(
        id: widget.rumah.id,
        alamat: _alamatController.text.trim(),
        statusRumah: _statusRumah!,
        createdAt: widget.rumah.createdAt,
        riwayatPenghuni: widget.rumah.riwayatPenghuni,
      );

      context.read<RumahBloc>().add(UpdateRumahEvent(rumahData));
    }
  }

  // Helper text status untuk display
  String _getStatusDisplay(String status) {
    switch (status.toLowerCase()) {
      case 'kosong':
        return 'Tersedia';
      case 'dihuni':
        return 'Ditempati';
      case 'disewakan':
        return 'Disewakan';
      default:
        return status;
    }
  }

  // Helper warna status
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'kosong':
        return Colors.green.shade700;
      case 'dihuni':
        return Colors.blue.shade700;
      case 'disewakan':
        return Colors.orange.shade700;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<RumahBloc, RumahState>(
      listener: (context, state) {
        if (state is RumahLoading) {
          setState(() => _isLoading = true);
        } else {
          setState(() => _isLoading = false);
        }

        if (state is RumahActionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true);
        } else if (state is RumahError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text(
            "Edit Data Rumah",
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
                    // --- DATA RUMAH ---
                    _buildSectionHeader('Data Rumah', Icons.home),
                    const SizedBox(height: 12),

                    // ID Rumah - Disabled
                    TextFormField(
                      initialValue: widget.rumah.id.toString(),
                      enabled: false,
                      style: TextStyle(color: Colors.grey[700]),
                      decoration: InputDecoration(
                        labelText: "ID Rumah",
                        prefixIcon: Icon(Icons.tag, color: Colors.grey[500]),
                        disabledBorder: _inputBorder(Colors.grey[300]!),
                        filled: true,
                        fillColor: Colors.grey[200],
                        helperText: "ID rumah tidak dapat diubah",
                        helperStyle: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 11,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Alamat
                    TextFormField(
                      controller: _alamatController,
                      cursorColor: theme.colorScheme.primary,
                      style: theme.textTheme.bodyMedium,
                      validator: (value) =>
                          value?.isEmpty == true ? 'Alamat wajib diisi' : null,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: "Alamat Rumah *",
                        hintText: "Masukkan alamat rumah",
                        alignLabelWithHint: true,
                        prefixIcon: const Padding(
                          padding: EdgeInsets.only(bottom: 50),
                          child: Icon(Icons.location_on),
                        ),
                        enabledBorder: _inputBorder(theme.dividerColor),
                        focusedBorder: _inputBorder(theme.colorScheme.primary),
                        errorBorder: _inputBorder(Colors.red),
                        focusedErrorBorder: _inputBorder(Colors.red),
                        filled: true,
                        fillColor: AppColors.secondBackground,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // --- STATUS RUMAH ---
                    _buildSectionHeader('Status Hunian', Icons.house_siding),
                    const SizedBox(height: 12),

                    // Dropdown Status
                    DropdownButtonFormField<String>(
                      value: _statusRumah,
                      decoration: InputDecoration(
                        labelText: "Status Rumah *",
                        prefixIcon: const Icon(Icons.verified_user),
                        enabledBorder: _inputBorder(theme.dividerColor),
                        focusedBorder: _inputBorder(theme.colorScheme.primary),
                        filled: true,
                        fillColor: AppColors.secondBackground,
                      ),
                      items: statusRumahOptions.map((e) {
                        final displayText = _getStatusDisplay(e);
                        final color = _getStatusColor(e);
                        return DropdownMenuItem(
                          value: e,
                          child: Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(displayText),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (val) => setState(() => _statusRumah = val),
                    ),
                    const SizedBox(height: 12),

                    // Info box status
                    if (_statusRumah != null)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _getStatusColor(
                            _statusRumah!,
                          ).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: _getStatusColor(
                              _statusRumah!,
                            ).withOpacity(0.5),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: _getStatusColor(_statusRumah!),
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Status Saat Ini",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: _getStatusColor(_statusRumah!),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    _getStatusDisplay(_statusRumah!),
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: _getStatusColor(_statusRumah!),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _getStatusDescription(_statusRumah!),
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: _getStatusColor(
                                        _statusRumah!,
                                      ).withOpacity(0.8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 24),

                    // --- RIWAYAT PENGHUNI INFO ---
                    if (widget.rumah.riwayatPenghuni.isNotEmpty) ...[
                      _buildSectionHeader(
                        'Riwayat Penghuni (${widget.rumah.riwayatPenghuni.length})',
                        Icons.history,
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.blue.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Colors.blue.shade700,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                "Rumah ini memiliki ${widget.rumah.riwayatPenghuni.length} riwayat penghuni. Lihat detail untuk informasi lengkap.",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.blue.shade700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],

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

  String _getStatusDescription(String status) {
    switch (status.toLowerCase()) {
      case 'kosong':
        return 'Rumah dalam keadaan kosong dan siap untuk ditempati atau disewakan.';
      case 'dihuni':
        return 'Rumah sedang ditempati oleh penghuni tetap.';
      case 'disewakan':
        return 'Rumah sedang dalam status disewakan kepada pihak lain.';
      default:
        return '';
    }
  }
}
