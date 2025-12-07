import 'package:flutter/material.dart';
import 'package:jawara_pintar_mobile_version/core/theme/app_colors.dart';


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
                "/pemasukan_lain",
              ),
              _buildMenuItem(
                context,
                Icons.money_off,
                "Pengeluaran",
                "/daftar-pengeluaran",
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
                "Kategori\nTagihan",
                "/daftar-kategori-iuran",
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.pushNamed(context, route);
        },
        splashColor: AppColors.primary.withOpacity(0.1),
        highlightColor: AppColors.primary.withOpacity(0.05),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withOpacity(0.15),
                      AppColors.primary.withOpacity(0.08),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.2),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  color: AppColors.primary,
                  size: 28,
                ),
              ),
              const SizedBox(height: 8),
              Flexible(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 9,
                    height: 1.2,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
