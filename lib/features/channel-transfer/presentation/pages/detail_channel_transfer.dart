import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../widgets/image_view_page.dart';

import '../../domain/entities/channel_transfer_entities.dart';

class DetailTransferChannelPage extends StatelessWidget {
  final TransferChannel channel;

  const DetailTransferChannelPage({super.key, required this.channel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 3,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'Detail Channel Transfer',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                // Nama Channel
                Text(
                  channel.namaChannel,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Divider(),

                // DETAIL FIELDS
                _buildDetailItem('Tipe Channel', _tipeToString(channel.tipe)),
                _buildDetailItem(
                  'Nomor Rekening',
                  channel.nomorRekening?.isNotEmpty == true
                      ? channel.nomorRekening!
                      : '-',
                ),
                _buildDetailItem(
                  'Nama Pemilik',
                  channel.namaPemilik?.isNotEmpty == true
                      ? channel.namaPemilik!
                      : '-',
                ),
                _buildDetailItem(
                  'Catatan',
                  channel.catatan?.isNotEmpty == true ? channel.catatan! : '-',
                ),
               _buildDetailItem(
                  'Tanggal Dibuat',
                  channel.createdAt != null
                      ? _formatTanggal(channel.createdAt!)
                      : '-',
                ),
                const SizedBox(height: 16),
                const Text(
                  'QR & Thumbnail',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                // QR Image
                _buildImagePreview(
                  context: context,
                  imagePath: channel.qrUrl,
                  label: 'QR Code',
                ),
                const SizedBox(height: 12),

                // Thumbnail Image
                _buildImagePreview(
                  context: context,
                  imagePath: channel.thumbnailUrl,
                  label: 'Thumbnail',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _tipeToString(ChannelType tipe) {
    switch (tipe) {
      case ChannelType.Bank:
        return 'Bank';
      case ChannelType.EWallet:
        return 'E-Wallet';
      case ChannelType.QRIS:
        return 'QRIS';
    }
  }

  String _formatTanggal(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 160,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildImagePreview({
    required BuildContext context,
    required String? imagePath,
    required String label,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: imagePath != null && imagePath.isNotEmpty
              ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ImageViewPage(imageUrl: imagePath),
                    ),
                  );
                }
              : null,
          child: Container(
            height: 180,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: imagePath != null && imagePath.isNotEmpty
                ? Hero(
                    tag: imagePath,
                    child: Image.network(
                      imagePath,
                      fit: BoxFit.contain,
                      width: double.infinity,
                    ),
                  )
                : const Icon(Icons.image, size: 60, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}