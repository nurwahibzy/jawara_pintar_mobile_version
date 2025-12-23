import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/users.dart';
import '../bloc/users_bloc.dart';
import '../bloc/users_event.dart';
import '../bloc/users_state.dart';
import 'detail_users.dart';
import 'edit_users.dart';

class DaftarUsers extends StatefulWidget {
  const DaftarUsers({super.key});

  @override
  State<DaftarUsers> createState() => _DaftarUsersState();
}

class _DaftarUsersState extends State<DaftarUsers> {
  bool _showSearch = false; // Mengganti showFilter menjadi showSearch agar lebih simpel
  final TextEditingController _searchController = TextEditingController();
  List<Users> _allItems = [];

  @override
  void initState() {
    super.initState();
    // Load data users saat halaman dibuka
    context.read<UsersBloc>().add(LoadUsers());
  }

  // Logic pemfilteran data (Search)
  List<Users> get filteredUsers {
    if (_searchController.text.isEmpty) {
      return _allItems;
    }
    
    return _allItems.where((item) {
      // Asumsi model Users punya field 'name'. Jika tidak ada, ganti dengan field yang sesuai.
      // Kita cari berdasarkan Nama ATAU Role
      final searchLower = _searchController.text.toLowerCase();
      
      // Cek apakah field 'name' ada di entity Users Anda, jika tidak hapus baris ini
      // final nameMatch = item.nama.toLowerCase().contains(searchLower); 
      final roleMatch = item.role.toLowerCase().contains(searchLower);

      // return nameMatch || roleMatch;
      return  roleMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text(
          'Daftar Pengguna',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(
              _showSearch ? Icons.close : Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _showSearch = !_showSearch;
                if (!_showSearch) _searchController.clear();
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // PANEL PENCARIAN
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: _showSearch ? 80 : 0,
            child: _showSearch
                ? Padding(
                    padding: const EdgeInsets.all(12),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Cari nama atau role...',
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      ),
                      onChanged: (v) {
                        setState(() {}); // Refresh UI saat mengetik
                      },
                    ),
                  )
                : const SizedBox.shrink(),
          ),

          // LIST USER
          Expanded(
            child: BlocConsumer<UsersBloc, UsersState>(
              listener: (context, state) {
                if (state is UsersError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message), backgroundColor: Colors.red),
                  );
                } else if (state is UsersActionSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message), backgroundColor: Colors.green),
                  );
                  // Reload data setelah sukses hapus/edit
                  context.read<UsersBloc>().add(const LoadUsers());
                } else if (state is UsersLoaded) {
                  _allItems = state.items;
                }
              },
              builder: (context, state) {
                if (state is UsersLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is UsersEmpty) {
                  return const Center(child: Text('Belum ada pengguna'));
                } 
                
                // Gunakan getter filteredUsers
                final list = filteredUsers;

                if (list.isEmpty) {
                  return const Center(
                    child: Text(
                      'Data pengguna tidak ditemukan',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 80),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final item = list[index];
                    
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading: CircleAvatar(
                          backgroundColor: AppColors.primary,
                          child: Text(
                            item.status.isNotEmpty ? item.status[0].toUpperCase() : '?',
                            style: const TextStyle(color: AppColors.primary),
                          ),  
                        ),
                        title: Text(
                          item.nama?? 'kosong', // Pastikan field ini ada di entity Users
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(item.role),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: item.status == 'approved' ? Colors.green[100] : Colors.red[100],
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                item.status,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: item.status == 'approved' ? Colors.green[800] : Colors.red[800],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'detail') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DetailUsers(user: item),
                                ),
                              );
                            } else if (value == 'edit') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BlocProvider.value(
                                    value: context.read<UsersBloc>(),
                                    child: EditUsers(user: item), // Pastikan class EditUsers menerima parameter ini
                                  ),
                                ),
                              );
                            } else if (value == 'hapus') {
                              // Tampilkan dialog konfirmasi sebelum hapus
                              showDialog(
                                context: context, 
                                builder: (ctx) => AlertDialog(
                                  title: const Text("Hapus User"),
                                  content: const Text("Yakin ingin menghapus user ini?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(ctx), 
                                      child: const Text("Batal")
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(ctx);
                                        context.read<UsersBloc>().add(DeleteUsersEvent(item.id!));
                                      }, 
                                      child: const Text("Hapus", style: TextStyle(color: Colors.red))
                                    ),
                                  ],
                                )
                              );
                            }
                          },
                          itemBuilder: (_) => const [
                            PopupMenuItem(
                              value: 'detail',
                              child: Row(
                                children: [Icon(Icons.info_outline, size: 20), SizedBox(width: 8), Text("Detail")],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'edit',
                              child: Row(
                                children: [Icon(Icons.edit, size: 20), SizedBox(width: 8), Text("Edit")],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'hapus',
                              child: Row(
                                children: [Icon(Icons.delete, size: 20, color: Colors.red), SizedBox(width: 8), Text("Hapus", style: TextStyle(color: Colors.red))],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          final result = await Navigator.pushNamed(context, '/tambah-user');
          if (result == true) {
            if (!mounted) return;
            context.read<UsersBloc>().add(LoadUsers());
          }
        },
      ),
    );
  }
}