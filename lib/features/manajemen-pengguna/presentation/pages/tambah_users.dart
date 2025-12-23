import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../bloc/users_bloc.dart';
import '../bloc/users_event.dart';
import '../bloc/users_state.dart';

class TambahUsers extends StatefulWidget {
  const TambahUsers({super.key});

  @override
  State<TambahUsers> createState() => _TambahUsersState();
}

class _TambahUsersState extends State<TambahUsers> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _wargaIdController = TextEditingController();

  // Variables
  String? _selectedRole;
  bool _isPasswordVisible = false;

  // Options
  final List<String> _roleOptions = ['Admin', 'Warga', 'Bendahara'];

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _wargaIdController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && _selectedRole != null) {
      // Panggil Event AddUser
      // Pastikan Logic di Bloc sudah menangani pendaftaran ke Supabase Auth & Insert ke Tabel Users
      context.read<UsersBloc>().add(
        AddUser(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          wargaId: int.parse(_wargaIdController.text),
          role: _selectedRole!,
        ),
      );
    } else if (_selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap pilih Role pengguna')),
      );
    }
  }

  OutlineInputBorder _inputBorder(Color color) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: color, width: 1.5),
      );

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        centerTitle: true,
        title: const Text(
          "Tambah Pengguna Baru",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: BlocListener<UsersBloc, UsersState>(
        listener: (context, state) {
          if (state is UsersActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.green),
            );
            Navigator.pop(context, true); // Kembali dengan sukses
          } else if (state is UsersError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Buat Akun",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                // 1. EMAIL INPUT
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "Email",
                    hintText: "user@example.com",
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: _inputBorder(Colors.grey),
                    enabledBorder: _inputBorder(Colors.grey.shade300),
                    focusedBorder: _inputBorder(AppColors.primary),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Email wajib diisi';
                    if (!value.contains('@')) return 'Format email tidak valid';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // 2. PASSWORD INPUT
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: "Password",
                    hintText: "Masukkan password",
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                    border: _inputBorder(Colors.grey),
                    enabledBorder: _inputBorder(Colors.grey.shade300),
                    focusedBorder: _inputBorder(AppColors.primary),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Password wajib diisi';
                    if (value.length < 6) return 'Password minimal 6 karakter';
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 16),

                const Text(
                  "Data Pengguna",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                // 3. WARGA ID INPUT
                TextFormField(
                  controller: _wargaIdController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    labelText: "ID Warga",
                    hintText: "Masukkan ID Warga yang valid",
                    prefixIcon: const Icon(Icons.person_pin_circle_outlined),
                    border: _inputBorder(Colors.grey),
                    enabledBorder: _inputBorder(Colors.grey.shade300),
                    focusedBorder: _inputBorder(AppColors.primary),
                    filled: true,
                    fillColor: Colors.white,
                    helperText: "ID ini harus ada di tabel 'warga'",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Warga ID wajib diisi';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // 4. ROLE DROPDOWN
                DropdownButtonFormField<String>(
                  initialValue: _selectedRole,
                  decoration: InputDecoration(
                    labelText: "Role Pengguna",
                    prefixIcon: const Icon(Icons.admin_panel_settings_outlined),
                    border: _inputBorder(Colors.grey),
                    enabledBorder: _inputBorder(Colors.grey.shade300),
                    focusedBorder: _inputBorder(AppColors.primary),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  items: _roleOptions.map((role) {
                    return DropdownMenuItem(
                      value: role,
                      child: Text(role),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() => _selectedRole = val);
                  },
                  validator: (value) => value == null ? 'Pilih role' : null,
                ),

                const SizedBox(height: 40),

                // 5. TOMBOL SIMPAN
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 2,
                    ),
                    child: const Text(
                      "Buat Akun Pengguna",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
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