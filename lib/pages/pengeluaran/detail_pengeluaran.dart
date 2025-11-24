import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../features/pengeluaran/domain/entities/pengeluaran.dart';

class DetailPengeluaran extends StatelessWidget {
  final Pengeluaran pengeluaran;

  const DetailPengeluaran({super.key, required this.pengeluaran});

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 2,
        title: const Text(
          'Detail Pengeluaran',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
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
                _buildDetailItem(
                  'Kategori',
                  _mapKategoriIdToString(pengeluaran.kategoriTransaksiId),
                ),
                _buildDetailItem(
                  'Nominal',
                  currencyFormatter.format(pengeluaran.nominal),
                ),
                _buildDetailItem(
                  'Keterangan',
                  (pengeluaran.keterangan != null &&
                          pengeluaran.keterangan!.isNotEmpty)
                      ? pengeluaran.keterangan!
                      : '-',
                ),
                _buildDetailItem(
                  'Tanggal Verifikasi',
                  pengeluaran.tanggalVerifikasi != null
                      ? _formatTanggal(pengeluaran.tanggalVerifikasi!)
                      : '-',
                ),
                _buildDetailItem(
                  'Verifikator',
                  pengeluaran.verifikatorId?.toString() ?? '-',
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
                      ? Image.file(
                          File(pengeluaran.buktiFoto!),
                          height: 180,
                          fit: BoxFit.cover,
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

  // Helper to format date
  String _formatTanggal(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  // Map kategori ID ke nama
  String _mapKategoriIdToString(int id) {
    switch (id) {
      case 1:
        return "Dana Hibah/Donasi";
      case 2:
        return "Penjualan Sampah Daur Ulang";
      case 3:
        return "Operasional RT";
      case 4:
        return "Perbaikan Fasilitas";
      default:
        return "Lainnya";
    }
  }

  // Widget untuk detail item
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

  // Widget untuk menampilkan image atau placeholder
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