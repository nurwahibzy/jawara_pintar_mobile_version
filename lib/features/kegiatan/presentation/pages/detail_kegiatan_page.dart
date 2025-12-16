import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/kegiatan.dart';
import '../../domain/entities/transaksi_kegiatan.dart';
import '../bloc/kegiatan_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import 'form_kegiatan_page.dart';
import 'form_transaksi_kegiatan_page.dart';

class DetailKegiatanPage extends StatefulWidget {
  final int kegiatanId;

  const DetailKegiatanPage({super.key, required this.kegiatanId});

  @override
  State<DetailKegiatanPage> createState() => _DetailKegiatanPageState();
}

class _DetailKegiatanPageState extends State<DetailKegiatanPage> {
  final dateFormatter = DateFormat('dd MMMM yyyy', 'id_ID');
  final dateTimeFormatter = DateFormat('dd MMM yyyy HH:mm', 'id_ID');
  final currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  Kegiatan? _currentKegiatan;
  List<TransaksiKegiatan> _transaksiList = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    context.read<KegiatanBloc>().add(GetKegiatanDetailEvent(widget.kegiatanId));
    context.read<KegiatanBloc>().add(
      GetTransaksiKegiatanEvent(widget.kegiatanId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text(
          'Detail Kegiatan',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final state = context.read<KegiatanBloc>().state;
              if (state is KegiatanDetailLoaded) {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (buildContext) => BlocProvider.value(
                      value: BlocProvider.of<KegiatanBloc>(context),
                      child: FormKegiatanPage(kegiatan: state.kegiatan),
                    ),
                  ),
                );
                if (mounted) {
                  context.read<KegiatanBloc>().add(
                    GetKegiatanDetailEvent(widget.kegiatanId),
                  );
                }
              }
            },
          ),
        ],
      ),
      body: BlocConsumer<KegiatanBloc, KegiatanState>(
        listener: (context, state) {
          if (state is KegiatanError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is KegiatanDetailLoaded) {
            setState(() {
              _currentKegiatan = state.kegiatan;
            });
          } else if (state is TransaksiKegiatanLoaded) {
            setState(() {
              _transaksiList = state.transaksiList;
            });
          } else if (state is TransaksiActionSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
            _loadData();
          }
        },
        builder: (context, state) {
          if (_currentKegiatan == null && state is KegiatanLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (_currentKegiatan != null) {
            return _buildDetailContent(_currentKegiatan!);
          } else {
            return const Center(child: Text('Gagal memuat detail kegiatan'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (buildContext) => BlocProvider.value(
                value: BlocProvider.of<KegiatanBloc>(context),
                child: FormTransaksiKegiatanPage(kegiatanId: widget.kegiatanId),
              ),
            ),
          );
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Tambah Transaksi',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildDetailContent(Kegiatan kegiatan) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                const Icon(Icons.event, size: 60, color: Colors.white),
                const SizedBox(height: 16),
                Text(
                  kegiatan.namaKegiatan,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                if (kegiatan.namaKategori != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      kegiatan.namaKategori!,
                      style: const TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ),
                const SizedBox(height: 8),
                Text(
                  dateFormatter.format(kegiatan.tanggalPelaksanaan),
                  style: const TextStyle(fontSize: 16, color: Colors.white70),
                ),
              ],
            ),
          ),

          // Detail Information
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoCard('Informasi Kegiatan', [
                  _buildInfoRow('Deskripsi', kegiatan.deskripsi),
                  _buildInfoRow('Lokasi', kegiatan.lokasi),
                  _buildInfoRow('Penanggung Jawab', kegiatan.penanggungJawab),
                  _buildInfoRow(
                    'Dibuat pada',
                    dateTimeFormatter.format(kegiatan.createdAt),
                  ),
                ]),
                if (kegiatan.fotoDokumentasi != null) ...[
                  const SizedBox(height: 16),
                  _buildFotoCard(kegiatan.fotoDokumentasi!),
                ],
                const SizedBox(height: 16),
                _buildTransaksiSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransaksiSection() {
    final totalPemasukan = _transaksiList
        .where((t) => t.isPemasukan)
        .fold<double>(0, (sum, t) => sum + (t.nominal ?? 0));
    final totalPengeluaran = _transaksiList
        .where((t) => t.isPengeluaran)
        .fold<double>(0, (sum, t) => sum + (t.nominal ?? 0));
    final saldo = totalPemasukan - totalPengeluaran;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Summary Card
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ringkasan Keuangan',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildSummaryItem(
                        'Pemasukan',
                        totalPemasukan,
                        Colors.green,
                        Icons.arrow_downward,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildSummaryItem(
                        'Pengeluaran',
                        totalPengeluaran,
                        Colors.red,
                        Icons.arrow_upward,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: saldo >= 0
                        ? Colors.green.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Saldo',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: saldo >= 0
                              ? Colors.green[700]
                              : Colors.red[700],
                        ),
                      ),
                      Text(
                        currencyFormatter.format(saldo),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: saldo >= 0
                              ? Colors.green[700]
                              : Colors.red[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Transaksi List
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Riwayat Transaksi',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${_transaksiList.length} transaksi',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (_transaksiList.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Column(
                        children: [
                          Icon(
                            Icons.receipt_long,
                            size: 50,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Belum ada transaksi',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _transaksiList.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final transaksi = _transaksiList[index];
                      return _buildTransaksiItem(transaksi);
                    },
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryItem(
    String label,
    double amount,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 4),
              Text(label, style: TextStyle(fontSize: 12, color: color)),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            currencyFormatter.format(amount),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransaksiItem(TransaksiKegiatan transaksi) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: transaksi.isPemasukan
            ? Colors.green.withOpacity(0.1)
            : Colors.red.withOpacity(0.1),
        child: Icon(
          transaksi.isPemasukan ? Icons.arrow_downward : Icons.arrow_upward,
          color: transaksi.isPemasukan ? Colors.green : Colors.red,
          size: 20,
        ),
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              transaksi.judul ?? '-',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          if (transaksi.buktiFoto != null)
            const Icon(Icons.photo_camera, size: 16, color: Colors.blue),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            transaksi.tanggalTransaksi != null
                ? dateFormatter.format(transaksi.tanggalTransaksi!)
                : '-',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
          if (transaksi.namaCreatedBy != null)
            Text(
              'Oleh: ${transaksi.namaCreatedBy}',
              style: TextStyle(fontSize: 11, color: Colors.grey[500]),
            ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            currencyFormatter.format(transaksi.nominal ?? 0),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: transaksi.isPemasukan ? Colors.green : Colors.red,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete, size: 20),
            color: Colors.red,
            onPressed: () => _confirmDeleteTransaksi(transaksi),
          ),
        ],
      ),
      onTap: transaksi.buktiFoto != null
          ? () => _showFullScreenImage(transaksi.buktiFoto!)
          : null,
    );
  }

  void _confirmDeleteTransaksi(TransaksiKegiatan transaksi) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Transaksi'),
        content: Text(
          'Yakin ingin menghapus transaksi "${transaksi.judul ?? '-'}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<KegiatanBloc>().add(
                DeleteTransaksiKegiatanEvent(transaksi.id, widget.kegiatanId),
              );
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFotoCard(String fotoUrl) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Foto Dokumentasi',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => _showFullScreenImage(fotoUrl),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  fotoUrl,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 250,
                      color: Colors.grey[300],
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.broken_image,
                              size: 50,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Gagal memuat gambar',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: 250,
                      color: Colors.grey[200],
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tap untuk melihat gambar penuh',
              style: TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showFullScreenImage(String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                panEnabled: true,
                minScale: 0.5,
                maxScale: 4.0,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.broken_image,
                            size: 80,
                            color: Colors.white,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Gagal memuat gambar',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                            : null,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
              ),
            ),
            Positioned(
              top: 40,
              right: 16,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
