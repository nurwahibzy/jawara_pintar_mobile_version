
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jawara_pintar_mobile_version/core/theme/app_colors.dart';
import 'package:jawara_pintar_mobile_version/widgets/image_view_page.dart';

import '../../../../../features/pengeluaran/domain/entities/kategori_transaksi.dart';
import '../../../../../features/pengeluaran/domain/entities/pengeluaran.dart';

class DetailPengeluaran extends StatelessWidget {
  final Pengeluaran pengeluaran;
  final List<KategoriEntity> kategoriList;

  const DetailPengeluaran({
    super.key,
    required this.pengeluaran,
    required this.kategoriList,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    final kategoriNama =
        kategoriList
            .firstWhere(
              (k) => k.id == pengeluaran.kategoriTransaksiId,
              orElse: () => KategoriEntity(
                id: 0,
                jenis: 'Lainnya',
                nama_kategori: 'Lainnya',
              ),
            )
            .nama_kategori ??
        'Lainnya';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary, 
        elevation: 3,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'Detail Pengeluaran',
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
                // Judul
                Text(
                  pengeluaran.judul,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Divider(),

                // DETAIL FIELDS
                _buildDetailItem(
                  'Tanggal',
                  _formatTanggal(pengeluaran.tanggalTransaksi),
                ),
                _buildDetailItem('Kategori', kategoriNama),
                _buildDetailItem(
                  'Nominal',
                  currencyFormatter.format(pengeluaran.nominal),
                ),
                _buildDetailItem(
                  'Keterangan',
                  pengeluaran.keterangan?.isNotEmpty == true
                      ? pengeluaran.keterangan!
                      : '-',
                ),
               _buildDetailItem(
                  'Dibuat oleh',
                  pengeluaran.createdByName?.isNotEmpty == true
                      ? pengeluaran.createdByName!
                      : (pengeluaran.createdBy.isNotEmpty
                            ? pengeluaran.createdBy
                            : 'Unknown'),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Bukti Pengeluaran',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                // IMAGE
                _buildImagePlaceholder(
                  child: pengeluaran.buktiFoto != null
                      ? InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ImageViewPage(
                                  imageUrl: pengeluaran.buktiFoto!,
                                ),
                              ),
                            );
                          },
                          child: Hero(
                            tag: pengeluaran.buktiFoto!,
                            child: Image.network(
                              pengeluaran.buktiFoto!,
                              height: 180,
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : const Icon(Icons.image, size: 60, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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

  Widget _buildImagePlaceholder({Widget? child}) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: child ?? const Icon(Icons.image, size: 60, color: Colors.grey),
    );
  }
}