import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/tagihan_pembayaran.dart';
import '../bloc/tagihan_bloc.dart';
import '../../../../core/theme/app_colors.dart';

class DetailTagihanPembayaranPage extends StatefulWidget {
  final int tagihanId;

  const DetailTagihanPembayaranPage({super.key, required this.tagihanId});

  @override
  State<DetailTagihanPembayaranPage> createState() =>
      _DetailTagihanPembayaranPageState();
}

class _DetailTagihanPembayaranPageState
    extends State<DetailTagihanPembayaranPage> {
  final TextEditingController _catatanController = TextEditingController();

  final formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  final dateFormatter = DateFormat('dd MMM yyyy HH:mm', 'id_ID');

  @override
  void initState() {
    super.initState();
    context.read<TagihanBloc>().add(
      LoadTagihanPembayaranDetail(widget.tagihanId),
    );
  }

  @override
  void dispose() {
    _catatanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text(
          'Detail Tagihan Pembayaran',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: BlocConsumer<TagihanBloc, TagihanState>(
        listener: (context, state) {
          if (state is TagihanActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            // Reload detail
            context.read<TagihanBloc>().add(
              LoadTagihanPembayaranDetail(widget.tagihanId),
            );
          } else if (state is TagihanError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is TagihanLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TagihanDetailLoaded) {
            return _buildDetailContent(state.tagihan);
          } else {
            return const Center(child: Text('Gagal memuat detail tagihan'));
          }
        },
      ),
    );
  }

  Widget _buildDetailContent(TagihanPembayaran tagihan) {
    Color statusColor;
    IconData statusIcon;

    switch (tagihan.statusVerifikasi) {
      case 'Diterima':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'Ditolak':
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
      case 'Menunggu':
      case 'Pending':
        statusColor = Colors.orange;
        statusIcon = Icons.pending;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help_outline;
    }

    final canApprove =
        tagihan.statusVerifikasi == 'Pending' ||
        tagihan.statusVerifikasi == 'Menunggu';

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Status Banner
          Container(
            padding: const EdgeInsets.all(20),
            color: statusColor.withOpacity(0.1),
            child: Column(
              children: [
                Icon(statusIcon, size: 60, color: statusColor),
                const SizedBox(height: 12),
                Text(
                  tagihan.statusVerifikasi,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
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
                // Kode Tagihan
                _buildSectionTitle('Informasi Tagihan'),
                const SizedBox(height: 12),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildDetailRow(
                          'Kode Tagihan',
                          tagihan.kodeTagihan ?? '-',
                          bold: true,
                        ),
                        const Divider(height: 24),
                        _buildDetailRow('Nama Iuran', tagihan.namaIuran ?? '-'),
                        const Divider(height: 24),
                        _buildDetailRow('Periode', tagihan.periode ?? '-'),
                        const Divider(height: 24),
                        _buildDetailRow(
                          'Nominal',
                          formatter.format(tagihan.nominal ?? 0),
                          bold: true,
                          valueColor: AppColors.primary,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Informasi Pembayaran
                _buildSectionTitle('Informasi Pembayaran'),
                const SizedBox(height: 12),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildDetailRow('Metode Pembayaran', tagihan.metode),
                        const Divider(height: 24),
                        _buildDetailRow(
                          'Tanggal Bayar',
                          dateFormatter.format(tagihan.tanggalBayar),
                        ),
                        const Divider(height: 24),
                        _buildDetailRow('Bukti Transfer', tagihan.bukti),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Bukti Bayar Image
                _buildSectionTitle('Bukti Pembayaran'),
                const SizedBox(height: 12),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: tagihan.bukti.isNotEmpty
                      ? Image.network(
                          tagihan.bukti,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 200,
                              color: Colors.grey[200],
                              child: const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.broken_image,
                                      size: 48,
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
                        )
                      : Container(
                          height: 200,
                          color: Colors.grey[200],
                          child: const Center(
                            child: Text(
                              'Tidak ada bukti',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                ),

                if (tagihan.catatanAdmin != null &&
                    tagihan.catatanAdmin!.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  _buildSectionTitle('Catatan Admin'),
                  const SizedBox(height: 12),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        tagihan.catatanAdmin!,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 24),

                // Action Buttons (only show if status is Pending/Menunggu)
                if (canApprove) ...[
                  _buildSectionTitle('Tindakan'),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _showApproveDialog(tagihan.id),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.check_circle),
                          label: const Text(
                            'Setujui',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _showRejectDialog(tagihan.id),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.cancel),
                          label: const Text(
                            'Tolak',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value, {
    bool bold = false,
    Color? valueColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              color: valueColor,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

  void _showApproveDialog(int id) {
    _catatanController.clear();
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Setujui Pembayaran'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Apakah Anda yakin ingin menyetujui pembayaran ini?'),
              const SizedBox(height: 16),
              TextField(
                controller: _catatanController,
                decoration: const InputDecoration(
                  labelText: 'Catatan (Opsional)',
                  border: OutlineInputBorder(),
                  hintText: 'Masukkan catatan jika ada',
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                context.read<TagihanBloc>().add(
                  ApproveTagihan(
                    id: id,
                    catatan: _catatanController.text.isNotEmpty
                        ? _catatanController.text
                        : null,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text('Setujui'),
            ),
          ],
        );
      },
    );
  }

  void _showRejectDialog(int id) {
    _catatanController.clear();
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Tolak Pembayaran'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Apakah Anda yakin ingin menolak pembayaran ini?'),
              const SizedBox(height: 16),
              TextField(
                controller: _catatanController,
                decoration: const InputDecoration(
                  labelText: 'Catatan (Wajib)',
                  border: OutlineInputBorder(),
                  hintText: 'Berikan alasan penolakan',
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_catatanController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Catatan wajib diisi untuk penolakan'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                Navigator.pop(dialogContext);
                context.read<TagihanBloc>().add(
                  RejectTagihan(id: id, catatan: _catatanController.text),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Tolak'),
            ),
          ],
        );
      },
    );
  }
}
