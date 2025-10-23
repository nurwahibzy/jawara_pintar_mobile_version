import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

class Penerimaan {
  final String id;
  final String namaWarga;
  final double jumlah;
  final DateTime tanggal;
  final String? keterangan;

  Penerimaan({
    required this.id,
    required this.namaWarga,
    required this.jumlah,
    required this.tanggal,
    this.keterangan,
  });
}

class PenerimaanWargaPage extends StatefulWidget {
  const PenerimaanWargaPage({super.key});

  @override
  State<PenerimaanWargaPage> createState() => _PenerimaanWargaPageState();
}

class _PenerimaanWargaPageState extends State<PenerimaanWargaPage> {
  final List<Penerimaan> _penerimaanList = [];
  final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');

  void _tambahPenerimaan(Penerimaan data) {
    setState(() {
      _penerimaanList.add(data);
      _penerimaanList.sort((a, b) => b.tanggal.compareTo(a.tanggal));
    });
  }

  void _hapusPenerimaan(String id) {
    setState(() {
      _penerimaanList.removeWhere((item) => item.id == id);
    });
  }

  Future<void> _openTambahDialog() async {
    final result = await showDialog<Penerimaan?>(
      context: context,
      builder: (ctx) => TambahPenerimaanDialog(),
    );
    if (result != null) _tambahPenerimaan(result);
  }

  double get totalPenerimaan =>
      _penerimaanList.fold(0, (sum, item) => sum + item.jumlah);
      
        static get NumberFormat => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Penerimaan Warga'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Penerimaan:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    currencyFormat.format(totalPenerimaan),
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: _penerimaanList.isEmpty
                ? const Center(
                    child: Text('Belum ada data penerimaan.'),
                  )
                : ListView.builder(
                    itemCount: _penerimaanList.length,
                    itemBuilder: (ctx, i) {
                      final data = _penerimaanList[i];
                      return Dismissible(
                        key: ValueKey(data.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (_) => _hapusPenerimaan(data.id),
                        child: ListTile(
                          title: Text(data.namaWarga),
                          subtitle: Text(
                              '${DateFormat('dd MMM yyyy').format(data.tanggal)}${data.keterangan != null ? ' • ${data.keterangan}' : ''}'),
                          trailing: Text(currencyFormat.format(data.jumlah),
                              style: const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold)),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openTambahDialog,
        tooltip: 'Tambah Penerimaan',
        child: const Icon(Icons.add),
      ),
    );
  }
  
  DateFormat(String s) {}
}

class TambahPenerimaanDialog extends StatefulWidget {
  @override
  State<TambahPenerimaanDialog> createState() => _TambahPenerimaanDialogState();
}

class _TambahPenerimaanDialogState extends State<TambahPenerimaanDialog> {
  final _formKey = GlobalKey<FormState>();
  String _nama = '';
  double? _jumlah;
  String _keterangan = '';
  DateTime _tanggal = DateTime.now();

  Future<void> _pilihTanggal() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _tanggal,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _tanggal = picked);
  }

  void _simpan() {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final penerimaan = Penerimaan(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      namaWarga: _nama,
      jumlah: _jumlah!,
      tanggal: _tanggal,
      keterangan: _keterangan.isEmpty ? null : _keterangan,
    );
    Navigator.of(context).pop(penerimaan);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Tambah Penerimaan'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nama Warga'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Isi nama warga' : null,
                onSaved: (v) => _nama = v!.trim(),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Jumlah (Rp)'),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Isi jumlah';
                  final parsed = double.tryParse(v);
                  if (parsed == null || parsed <= 0) return 'Jumlah tidak valid';
                  return null;
                },
                onSaved: (v) => _jumlah = double.parse(v!),
              ),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Keterangan (opsional)'),
                onSaved: (v) => _keterangan = v ?? '',
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text('Tanggal: '),
                  Text(DateFormat('dd/MM/yyyy').format(_tanggal)),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: _pilihTanggal,
                    child: const Text('Pilih'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal')),
        ElevatedButton(onPressed: _simpan, child: const Text('Simpan')),
      ],
    );
  }
  
  DateFormat(String s) {}
}
