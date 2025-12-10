import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jawara_pintar_mobile_version/core/theme/app_colors.dart';
import 'package:jawara_pintar_mobile_version/manajemen-pengguna/domain/entities/users.dart';

import '../bloc/users_bloc.dart';
import '../bloc/users_event.dart';
import '../bloc/users_state.dart';

class EditUsers extends StatefulWidget {
  final Users user;

  const EditUsers({super.key, required this.user});

  @override
  State<EditUsers> createState() => _EditUsersState();
}

class _EditUsersState extends State<EditUsers> {
  // Controller hanya untuk nama (tampilan saja)
  late TextEditingController _namaController;

  // Variable untuk menyimpan pilihan Dropdown
  String? _selectedRole;
  String? _selectedStatus;

  // DAFTAR OPSI (Sesuaikan dengan database Anda)
  final List<String> _roleOptions = [
    'Admin',
    'Warga',
    'Bendahara',
  ];
  final List<String> _statusOptions = [
    'approved',
    'pending',
    'rejected',
  ];

  @override
  void initState() {
    super.initState();
    // Inisialisasi nilai awal dari data user yang dikirim
    _namaController = TextEditingController(text: widget.user.nama);

    // Pastikan nilai awal ada di dalam list opsi, jika tidak, masukkan sebagai default atau biarkan null
    _selectedRole = widget.user.role;
    _selectedStatus = widget.user.status;

    // Optional: Validasi jika data dari DB tidak ada di list opsi (Case Sensitive)
    if (!_roleOptions.contains(_selectedRole)) {
      _roleOptions.add(_selectedRole ?? 'Warga');
    }
    if (!_statusOptions.contains(_selectedStatus)) {
      _statusOptions.add(_selectedStatus ?? 'pending');
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    super.dispose();
  }

  void _simpanData() {
    if (_selectedRole == null || _selectedStatus == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Role dan Status harus dipilih')),
      );
      return;
    }

    // Buat object user baru dengan data yang diperbarui
    // Menggunakan copyWith agar ID dan data lain (auth_id, created_at) tidak hilang
    final updatedUser = widget.user.copyWith(
      role: _selectedRole,
      status: _selectedStatus,
    );

    // Kirim event update ke Bloc
    context.read<UsersBloc>().add(UpdateUsersEvent(updatedUser));
  }

  // Helper untuk styling input border
  OutlineInputBorder _inputBorder(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: color, width: 1.5),
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        centerTitle: true,
        title: const Text(
          "Edit Pengguna",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: BlocListener<UsersBloc, UsersState>(
        listener: (context, state) {
          if (state is UsersActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context, true); // Kembali dan beri sinyal sukses
          } else if (state is UsersError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. NAMA (READ ONLY)
              const Text(
                "Nama Lengkap",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _namaController,
                readOnly: true, // Tidak bisa diedit
                style: const TextStyle(
                  color: Colors.grey,
                ), // Visual cue bahwa ini disabled
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  enabledBorder: _inputBorder(Colors.grey.shade300),
                  focusedBorder: _inputBorder(Colors.grey.shade300),
                  prefixIcon: const Icon(Icons.person, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 20),

              // 2. ROLE (DROPDOWN)
              const Text(
                "Role Pengguna",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: _selectedRole,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: _inputBorder(theme.dividerColor),
                  focusedBorder: _inputBorder(AppColors.primary),
                  prefixIcon: const Icon(Icons.badge, color: AppColors.primary),
                ),
                items: _roleOptions.map((role) {
                  return DropdownMenuItem(value: role, child: Text(role));
                }).toList(),
                onChanged: (val) {
                  setState(() => _selectedRole = val);
                },
              ),
              const SizedBox(height: 20),

              // 3. STATUS (DROPDOWN)
              const Text(
                "Status Akun",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: _inputBorder(theme.dividerColor),
                  focusedBorder: _inputBorder(AppColors.primary),
                  prefixIcon: const Icon(
                    Icons.verified_user,
                    color: AppColors.primary,
                  ),
                ),
                items: _statusOptions.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(
                      status,
                      style: TextStyle(
                        color: status == 'approved'
                            ? Colors.green
                            : status == 'rejected'
                            ? Colors.red
                            : Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() => _selectedStatus = val);
                },
              ),

              const SizedBox(height: 40),

              // 4. BUTTONS
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: Colors.grey),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Batal",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _simpanData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Simpan Perubahan",
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
    );
  }
}
