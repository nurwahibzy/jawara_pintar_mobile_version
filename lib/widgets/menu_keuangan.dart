import 'package:flutter/material.dart';

class MenuKeuangan extends StatelessWidget {
  const MenuKeuangan({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: 4, 
            crossAxisSpacing: 12,
            mainAxisSpacing: 16,
            childAspectRatio: 0.85, 
            children: [
              _buildMenuItem(
                context,
                Icons.add_card,
                "Pemasukan",
                "/pemasukan",
              ),
              _buildMenuItem(
                context,
                Icons.money_off,
                "Pengeluaran",
                "/pengeluaran",
              ),
              _buildMenuItem(
                context,
                Icons.list_alt,
                "Tagihan",
                "/daftar_tagihan",
              ),
              _buildMenuItem(
                context,
                Icons.receipt,
                "Tagih\nIuran",
                "/tagih-iuran",
              ),
              _buildMenuItem(
                context,
                Icons.category,
                "Kategori\nIuran",
                "/kategori-iuran",
              ),
              _buildMenuItem(
                context,
                Icons.account_balance,
                "Channel\nTransfer",
                "/channel-transfer",
              ),
              _buildMenuItem(
                context,
                Icons.bar_chart,
                "Laporan\nKeuangan",
                "/laporan-keuangan",
              ),
              _buildMenuItem(
                context,
                Icons.print,
                "Cetak\nLaporan",
                "/cetak-laporan",
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    IconData icon,
    String label,
    String route,
  ) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.withAlpha(1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.green, size: 28),
          ),
          const SizedBox(height: 6),
          Flexible(
            child: Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
