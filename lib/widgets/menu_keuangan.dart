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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: 4, // jumlah kolom
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1,
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
              _buildMenuItem(context, Icons.list_alt, "Tagihan", "/tagihan"),
              _buildMenuItem(
                context,
                Icons.receipt,
                "Tagih Iuran",
                "/tagih-iuran",
              ),
              _buildMenuItem(
                context,
                Icons.category,
                "Kategori Iuran",
                "/kategori-iuran",
              ),
              _buildMenuItem(
                context,
                Icons.account_balance,
                "Channel Transfer",
                "/channel-transfer",
              ),
              _buildMenuItem(
                context,
                Icons.bar_chart,
                "Laporan Keuangan",
                "/laporan-keuangan",
              ),
              _buildMenuItem(
                context,
                Icons.print,
                "Cetak Laporan",
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
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
