import 'package:flutter/material.dart';

class MutasiKeluargaPage extends StatefulWidget {
  const MutasiKeluargaPage({super.key});

  @override
  State<MutasiKeluargaPage> createState() => _MutasiKeluargaPageState();
}

class _MutasiKeluargaPageState extends State<MutasiKeluargaPage> {
  final List<Map<String, String>> _mutasiList = [];
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _alamatBaruController = TextEditingController();

  void _tambahMutasi() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _mutasiList.add({
          'nama': _namaController.text,
          'alamatBaru': _alamatBaruController.text,
        });
        _namaController.clear();
        _alamatBaruController.clear();
      });
      Navigator.pop(context); // kembali ke daftar
    }
  }

  void _bukaFormTambah() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Form(
            key: _formKey,
            child: Wrap(
              children: [
                const Text(
                  'Tambah Mutasi Keluarga',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  controller: _namaController,
                  decoration: const InputDecoration(labelText: 'Nama Anggota'),
                  validator: (value) =>
                      value!.isEmpty ? 'Nama tidak boleh kosong' : null,
                ),
                TextFormField(
                  controller: _alamatBaruController,
                  decoration: const InputDecoration(labelText: 'Alamat Baru'),
                  validator: (value) =>
                      value!.isEmpty ? 'Alamat baru harus diisi' : null,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: const Text('Simpan'),
                  onPressed: _tambahMutasi,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mutasi Keluarga'),
        backgroundColor: Colors.blueAccent,
      ),
      body: _mutasiList.isEmpty
          ? const Center(child: Text('Belum ada data mutasi keluarga'))
          : ListView.builder(
              itemCount: _mutasiList.length,
              itemBuilder: (context, index) {
                final item = _mutasiList[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    leading: const Icon(Icons.people_alt_rounded),
                    title: Text(item['nama']!),
                    subtitle: Text('Alamat Baru: ${item['alamatBaru']}'),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _bukaFormTambah,
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
      ),
    );
  }
}
