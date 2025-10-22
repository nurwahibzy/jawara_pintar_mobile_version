import 'package:flutter/material.dart';
import 'package:jawara_pintar_mobile_version/pages/tagihan/riwayat_tagihan.dart';

class DetailTagihan extends StatefulWidget {
  final Map<String, dynamic> tagihan;

  const DetailTagihan({super.key, required this.tagihan});

  @override
  State<DetailTagihan> createState() => _DetailTagihanState();
}

class _DetailTagihanState extends State<DetailTagihan> {
  int _selectedTabIndex = 0;
  final TextEditingController _alasanController = TextEditingController();

  @override
  void dispose() {
    _alasanController.dispose();
    super.dispose();
  }

  // Helper widget untuk membuat baris detail
  Widget _buildDetailRow(
    String label,
    String value, {
    Color valueColor = Colors.black,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(label,
              style: const TextStyle(color: Colors.grey, fontSize: 14)),
          const SizedBox(height: 4),
          Text(
            value.isEmpty ? '-' : value,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  void _showVerifikasiDialog(bool isApprove) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isApprove ? 'Setujui Pembayaran' : 'Tolak Pembayaran'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isApprove
                    ? 'Apakah Anda yakin ingin menyetujui pembayaran ini?'
                    : 'Apakah Anda yakin ingin menolak pembayaran ini?',
              ),
              if (!isApprove) ...[
                const SizedBox(height: 16),
                TextField(
                  controller: _alasanController,
                  decoration: const InputDecoration(
                    labelText: 'Alasan Penolakan',
                    border: OutlineInputBorder(),
                    hintText: 'Tulis alasan penolakan...',
                  ),
                  maxLines: 3,
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(isApprove
                        ? 'Pembayaran berhasil disetujui'
                        : 'Pembayaran berhasil ditolak'),
                    backgroundColor: isApprove ? Colors.green : Colors.red,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isApprove ? Colors.green : Colors.red,
                foregroundColor: Colors.white,
              ),
              child: Text(isApprove ? 'Setujui' : 'Tolak'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Format data
    final periode = widget.tagihan['periode'] as DateTime;
    final String formattedPeriode =
        '${_getMonthName(periode.month)} ${periode.year}';
    final double nominal = (widget.tagihan['nominal'] as num).toDouble();
    final String formattedNominal =
        'Rp ${nominal.toStringAsFixed(0).replaceAllMapped(
              RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
              (Match m) => '${m[1]}.',
            )}';

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Verifikasi Pembayaran Iuran',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.green),
      ),
      body: Column(
        children: [
          // Tab buttons
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedTabIndex = 0;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedTabIndex == 0
                          ? Colors.green
                          : Colors.grey.shade300,
                      foregroundColor: _selectedTabIndex == 0
                          ? Colors.white
                          : Colors.black87,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Detail'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedTabIndex = 1;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedTabIndex == 1
                          ? Colors.green
                          : Colors.grey.shade300,
                      foregroundColor: _selectedTabIndex == 1
                          ? Colors.white
                          : Colors.black87,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Riwayat Pembayaran'),
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: _selectedTabIndex == 0
                ? _buildDetailTab(formattedPeriode, formattedNominal)
                : _buildRiwayatTab(),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailTab(String formattedPeriode, String formattedNominal) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow('Kode Iuran', widget.tagihan['id'] ?? '-'),
                    _buildDetailRow(
                        'Nama Iuran', widget.tagihan['jenisIuran'] ?? '-'),
                    _buildDetailRow('Kategori', 'Iuran Khusus'),
                    _buildDetailRow('Periode', formattedPeriode),
                    _buildDetailRow('Nominal', formattedNominal,
                        valueColor: Colors.green.shade700),
                    _buildDetailRow(
                        'Status',
                        widget.tagihan['statusPembayaran'] == 'Lunas'
                            ? 'paid'
                            : 'unpaid'),
                    _buildDetailRow(
                        'Nama KK', widget.tagihan['namaWarga'] ?? '-'),
                    _buildDetailRow('Alamat', widget.tagihan['alamat'] ?? '-'),
                    _buildDetailRow('Metode Pembayaran', 'Belum tersedia'),
                    _buildDetailRow('Bukti', ''),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // TextField untuk alasan penolakan
            TextField(
              controller: _alasanController,
              decoration: InputDecoration(
                labelText: 'Tulis alasan penolakan...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 16),

            // Tombol Setujui dan Tolak
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _showVerifikasiDialog(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
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
                  child: ElevatedButton(
                    onPressed: () => _showVerifikasiDialog(false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink.shade300,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
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
          ],
        ),
      ),
    );
  }

  Widget _buildRiwayatTab() {
    return RiwayatTagihan(tagihan: widget.tagihan);
  }

  String _getMonthName(int month) {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];
    return months[month - 1];
  }
}
