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

    switch (tagihan.statusTagihan ?? tagihan.statusVerifikasi) {
      case 'Lunas':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'Belum Lunas':
        statusColor = Colors.orange;
        statusIcon = Icons.pending;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help_outline;
    }

    final canApprove = tagihan.statusTagihan == 'Belum Lunas';
    final hasRiwayatPembayaran = tagihan.riwayatPembayaranId != null;

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
                  tagihan.statusTagihan ?? tagihan.statusVerifikasi,
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
                        _buildDetailRow(
                          'Jatuh Tempo',
                          dateFormatter.format(tagihan.tanggalBayar),
                        ),
                      ],
                    ),
                  ),
                ),

                // Informasi Metode Pembayaran
                if (hasRiwayatPembayaran) ...[
                  const SizedBox(height: 24),
                  _buildSectionTitle('Metode Pembayaran'),
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
                            'Metode',
                            tagihan.metodePembayaran ?? '-',
                            bold: true,
                          ),
                          const Divider(height: 24),
                          _buildDetailRow(
                            'Tanggal Bayar',
                            tagihan.tanggalBayarRiwayat != null
                                ? dateFormatter.format(
                                    tagihan.tanggalBayarRiwayat!,
                                  )
                                : '-',
                          ),
                          const Divider(height: 24),
                          _buildDetailRow(
                            'Status Verifikasi',
                            tagihan.statusVerifikasiRiwayat ?? '-',
                            bold: true,
                            valueColor:
                                tagihan.statusVerifikasiRiwayat == 'Verified'
                                ? Colors.green
                                : Colors.orange,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],

                // Bukti Bayar Image (hanya tampilkan jika ada riwayat pembayaran)
                if (hasRiwayatPembayaran &&
                    tagihan.buktiBayar != null &&
                    tagihan.buktiBayar!.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  _buildSectionTitle('Bukti Pembayaran Transfer'),
                  const SizedBox(height: 12),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.network(
                      tagihan.buktiBayar!,
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
                    ),
                  ),
                ],

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

                // Action Buttons (only show if status is Belum Lunas)
                if (canApprove) ...[
                  _buildSectionTitle('Tindakan'),
                  const SizedBox(height: 12),

                  // Jika ada riwayat pembayaran (Transfer)
                  if (hasRiwayatPembayaran) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue[200]!),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.blue[700]),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Warga telah melakukan pembayaran via transfer. Silakan verifikasi bukti pembayaran.',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.blue[900],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () =>
                            _showApproveDialog(tagihan.id, isTransfer: true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.verified, size: 24),
                        label: const Text(
                          'Verifikasi Pembayaran Transfer',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ]
                  // Jika tidak ada riwayat pembayaran (Cash)
                  else ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.orange[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.orange[200]!),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.orange[700]),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Belum ada pembayaran transfer. Jika warga membayar tunai, tandai sebagai lunas.',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.orange[900],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () =>
                            _showApproveDialog(tagihan.id, isTransfer: false),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.payments, size: 24),
                        label: const Text(
                          'Tandai Sudah Lunas (Cash)',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
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

  void _showApproveDialog(int id, {required bool isTransfer}) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            isTransfer
                ? 'Verifikasi Pembayaran Transfer'
                : 'Konfirmasi Pembayaran Cash',
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isTransfer
                    ? 'Apakah Anda yakin pembayaran transfer sudah valid dan ingin menandai tagihan ini sebagai LUNAS?'
                    : 'Apakah Anda yakin warga telah membayar secara tunai dan ingin menandai tagihan ini sebagai LUNAS?',
              ),
              const SizedBox(height: 8),
              Text(
                'Status tagihan akan berubah dari "Belum Lunas" menjadi "Lunas".',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              if (isTransfer) ...[
                const SizedBox(height: 8),
                Text(
                  'Pastikan bukti transfer sudah sesuai dengan nominal tagihan.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.orange[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ] else ...[
                const SizedBox(height: 8),
                Text(
                  'Uang tunai harus sudah diterima oleh bendahara.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.orange[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
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
                context.read<TagihanBloc>().add(ApproveTagihan(id: id));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: Text(isTransfer ? 'Ya, Verifikasi' : 'Ya, Tandai Lunas'),
            ),
          ],
        );
      },
    );
  }
}
