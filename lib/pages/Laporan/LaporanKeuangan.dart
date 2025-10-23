import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:intl/intl.dart';

/// Enum tipe transaksi
enum TransactionType { income, expense }

/// Model transaksi
class Transaction {
  final String id;
  final String title;
  final double amount;
  final TransactionType type;
  final DateTime date;
  final String? note;

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.date,
    this.note,
  });
}

/// Halaman utama laporan keuangan
class LaporanKeuangan extends StatefulWidget {
  const LaporanKeuangan({super.key}); // ✅ diperbaiki

  @override
  State<LaporanKeuangan> createState() => _LaporanKeuanganState();
}

class _LaporanKeuanganState extends State<LaporanKeuangan> {
  final List<Transaction> _transactions = [];
  final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');

  double get totalIncome => _transactions
      .where((t) => t.type == TransactionType.income)
      .fold(0.0, (p, e) => p + e.amount);

  double get totalExpense => _transactions
      .where((t) => t.type == TransactionType.expense)
      .fold(0.0, (p, e) => p + e.amount);
      
        static get NumberFormat => null;

  void _addTransaction(Transaction tx) {
    setState(() {
      _transactions.add(tx);
      _transactions.sort((a, b) => b.date.compareTo(a.date));
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _transactions.removeWhere((t) => t.id == id);
    });
  }

  Future<void> _openAddDialog() async {
    final result = await showDialog<Transaction?>(
      context: context,
      builder: (ctx) => AddTransactionDialog(),
    );
    if (result != null) _addTransaction(result);
  }

  Future<void> _generateAndCopyReport() async {
    final report = _buildReportText();
    await Clipboard.setData(ClipboardData(text: report));
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Laporan Disalin'),
        content: const Text(
            'Teks laporan berhasil disalin ke clipboard. Tempelkan ke dokumen atau aplikasi lain untuk mencetak.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Tutup'),
          )
        ],
      ),
    );
  }

  String _buildReportText() {
    final buffer = StringBuffer();
    buffer.writeln('LAPORAN KEUANGAN');
    buffer.writeln(
        'Tanggal: ${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now())}\n');
    buffer.writeln('TOTAL PEMASUKAN : ${currencyFormat.format(totalIncome)}');
    buffer.writeln('TOTAL PENGELUARAN: ${currencyFormat.format(totalExpense)}');
    buffer.writeln(
        'SALDO BERSIH     : ${currencyFormat.format(totalIncome - totalExpense)}\n');

    buffer.writeln('DETAIL PEMASUKAN:');
    final incomes =
        _transactions.where((t) => t.type == TransactionType.income).toList();
    if (incomes.isEmpty) {
      buffer.writeln('- (tidak ada pemasukan)');
    } else {
      for (var t in incomes) {
        buffer.writeln(
            '${DateFormat('yyyy-MM-dd').format(t.date)} | ${t.title} | ${currencyFormat.format(t.amount)} ${t.note != null ? "| ${t.note}" : ""}');
      }
    }

    buffer.writeln('\nDETAIL PENGELUARAN:');
    final expenses =
        _transactions.where((t) => t.type == TransactionType.expense).toList();
    if (expenses.isEmpty) {
      buffer.writeln('- (tidak ada pengeluaran)');
    } else {
      for (var t in expenses) {
        buffer.writeln(
            '${DateFormat('yyyy-MM-dd').format(t.date)} | ${t.title} | ${currencyFormat.format(t.amount)} ${t.note != null ? "| ${t.note}" : ""}');
      }
    }

    buffer.writeln('\n--- akhir laporan ---');
    return buffer.toString();
  }

  void _openReportPreview() {
    final reportText = _buildReportText();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => ReportPreviewPage(reportText: reportText),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _summaryColumn('Pemasukan', totalIncome),
            _summaryColumn('Pengeluaran', totalExpense),
            _summaryColumn('Saldo', totalIncome - totalExpense),
          ],
        ),
      ),
    );
  }

  Widget _summaryColumn(String title, double value) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(currencyFormat.format(value),
            style: const TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget _buildTransactionList() {
    if (_transactions.isEmpty) {
      return const Center(
          child: Text('Belum ada transaksi. Tekan + untuk menambah.'));
    }
    return ListView.builder(
      itemCount: _transactions.length,
      itemBuilder: (ctx, i) {
        final t = _transactions[i];
        return Dismissible(
          key: ValueKey(t.id),
          background: Container(
            color: Colors.redAccent,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          direction: DismissDirection.endToStart,
          onDismissed: (_) => _deleteTransaction(t.id),
          child: ListTile(
            leading: CircleAvatar(
              radius: 28,
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: FittedBox(
                  child: Text(currencyFormat.format(t.amount)),
                ),
              ),
            ),
            title: Text(t.title),
            subtitle: Text(
              '${DateFormat('yyyy-MM-dd').format(t.date)}'
              '${t.note != null ? ' • ${t.note}' : ''}',
            ),
            trailing: Icon(
              t.type == TransactionType.income
                  ? Icons.arrow_downward
                  : Icons.arrow_upward,
              color: t.type == TransactionType.income
                  ? Colors.green
                  : Colors.red,
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
        title: const Text('Laporan Keuangan'),
        actions: [
          IconButton(
            onPressed: _openReportPreview,
            icon: const Icon(Icons.preview),
            tooltip: 'Pratinjau Laporan',
          ),
          IconButton(
            onPressed: _generateAndCopyReport,
            icon: const Icon(Icons.print),
            tooltip: 'Cetak / Salin Laporan',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSummaryCard(),
          Expanded(child: _buildTransactionList()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddDialog,
        child: const Icon(Icons.add),
        tooltip: 'Tambah Transaksi',
      ),
    );
  }
  
  DateFormat(String s) {}
}

/// -----------------
/// Dialog Tambah Transaksi
/// -----------------
class AddTransactionDialog extends StatefulWidget {
  @override
  State<AddTransactionDialog> createState() => _AddTransactionDialogState();
}

class _AddTransactionDialogState extends State<AddTransactionDialog> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _note = '';
  double? _amount;
  TransactionType _type = TransactionType.income;
  DateTime _selectedDate = DateTime.now();

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final tx = Transaction(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: _title,
      amount: _amount!,
      type: _type,
      date: _selectedDate,
      note: _note.isEmpty ? null : _note,
    );
    Navigator.of(context).pop(tx);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Tambah Transaksi'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Judul'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Masukkan judul' : null,
                onSaved: (v) => _title = v!.trim(),
              ),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Jumlah (contoh: 150000)'),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Masukkan jumlah';
                  final parsed =
                      double.tryParse(v.replaceAll(',', '').replaceAll(' ', ''));
                  if (parsed == null || parsed <= 0) return 'Jumlah tidak valid';
                  return null;
                },
                onSaved: (v) => _amount = double.parse(
                    v!.replaceAll(',', '').replaceAll(' ', '')),
              ),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Catatan (opsional)'),
                onSaved: (v) => _note = v?.trim() ?? '',
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text('Tipe: '),
                  const SizedBox(width: 8),
                  DropdownButton<TransactionType>(
                    value: _type,
                    items: const [
                      DropdownMenuItem(
                          value: TransactionType.income,
                          child: Text('Pemasukan')),
                      DropdownMenuItem(
                          value: TransactionType.expense,
                          child: Text('Pengeluaran')),
                    ],
                    onChanged: (v) => setState(() => _type = v!),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text('Tanggal: '),
                  const SizedBox(width: 8),
                  Text(DateFormat('yyyy-MM-dd').format(_selectedDate)),
                  const SizedBox(width: 12),
                  TextButton(onPressed: _pickDate, child: const Text('Ubah')),
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
        ElevatedButton(onPressed: _submit, child: const Text('Simpan')),
      ],
    );
  }
  
  DateFormat(String s) {}
}

/// -----------------
/// Pratinjau Laporan
/// -----------------
class ReportPreviewPage extends StatelessWidget {
  final String reportText;
  const ReportPreviewPage({super.key, required this.reportText});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pratinjau Laporan'),
        actions: [
          IconButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: reportText));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Laporan disalin ke clipboard')),
              );
            },
            icon: const Icon(Icons.copy),
            tooltip: 'Salin Laporan',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: SelectableText(reportText),
        ),
      ),
    );
  }
}
