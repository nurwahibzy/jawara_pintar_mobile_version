import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/pemasukan.dart';
import '../bloc/pemasukan_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import 'form_pemasukan_page.dart';

class DetailPemasukanPage extends StatefulWidget {
  final int pemasukanId;

  const DetailPemasukanPage({super.key, required this.pemasukanId});

  @override
  State<DetailPemasukanPage> createState() => _DetailPemasukanPageState();
}

class _DetailPemasukanPageState extends State<DetailPemasukanPage> {
  final formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  final dateFormatter = DateFormat('dd MMM yyyy HH:mm', 'id_ID');

  @override
  void initState() {
    super.initState();
    context.read<PemasukanBloc>().add(
      GetPemasukanDetailEvent(widget.pemasukanId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text(
          'Detail Pemasukan',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final state = context.read<PemasukanBloc>().state;
              if (state is PemasukanDetailLoaded) {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (buildContext) => BlocProvider.value(
                      value: BlocProvider.of<PemasukanBloc>(context),
                      child: FormPemasukanPage(pemasukan: state.pemasukan),
                    ),
                  ),
                );
                if (mounted) {
                  context.read<PemasukanBloc>().add(
                    GetPemasukanDetailEvent(widget.pemasukanId),
                  );
                }
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showDeleteConfirmation(),
          ),
        ],
      ),
      body: BlocConsumer<PemasukanBloc, PemasukanState>(
        listener: (context, state) {
          if (state is PemasukanActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          } else if (state is PemasukanError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is PemasukanLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PemasukanDetailLoaded) {
            return _buildDetailContent(state.pemasukan);
          } else {
            return const Center(child: Text('Gagal memuat detail pemasukan'));
          }
        },
      ),
    );
  }

  Widget _buildDetailContent(Pemasukan pemasukan) {
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
                const Icon(
                  Icons.account_balance_wallet,
                  size: 60,
                  color: Colors.white,
                ),
                const SizedBox(height: 16),
                Text(
                  formatter.format(pemasukan.nominal),
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  pemasukan.namaKategori ?? '-',
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
                _buildInfoCard('Informasi Pemasukan', [
                  _buildInfoRow('Judul', pemasukan.judul),
                  _buildInfoRow(
                    'Tanggal Transaksi',
                    pemasukan.tanggalTransaksi,
                  ),
                  _buildInfoRow('Keterangan', pemasukan.keterangan),
                  if (pemasukan.buktiFoto != null)
                    _buildInfoRow('Bukti Foto', pemasukan.buktiFoto!),
                ]),
                const SizedBox(height: 16),
                _buildInfoCard('Informasi Sistem', [
                  _buildInfoRow(
                    'Dibuat pada',
                    dateFormatter.format(pemasukan.createdAt),
                  ),
                  _buildInfoRow('Dibuat oleh', pemasukan.createdBy.toString()),
                  if (pemasukan.verifikatorId != null)
                    _buildInfoRow(
                      'Verifikator',
                      pemasukan.verifikatorId.toString(),
                    ),
                  if (pemasukan.tanggalVerifikasi != null)
                    _buildInfoRow(
                      'Tanggal Verifikasi',
                      dateFormatter.format(pemasukan.tanggalVerifikasi!),
                    ),
                ]),
              ],
            ),
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

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: const Text(
          'Apakah Anda yakin ingin menghapus data pemasukan ini?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<PemasukanBloc>().add(
                DeletePemasukanEvent(widget.pemasukanId),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}
