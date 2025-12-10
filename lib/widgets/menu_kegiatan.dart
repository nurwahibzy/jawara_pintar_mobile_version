import 'package:flutter/material.dart';
import 'package:jawara_pintar_mobile_version/core/theme/app_colors.dart';

class MenuKegiatan extends StatelessWidget {
  const MenuKegiatan({super.key});

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
            mainAxisSpacing: 16,
            // PERUBAHAN 1: Ubah aspect ratio menjadi 0.70 agar kotak lebih tinggi
            childAspectRatio: 0.70, 
            children: [
              _buildMenuItem(
                context,
                Icons.event,
                "Daftar\nKegiatan",
                "/daftar-kegiatan",
              ),
              _buildMenuItem(
                context,
                Icons.campaign,
                "Broadcast",
                "/broadcast",
              ),
              _buildMenuItem(
                context,
                Icons.message_rounded,
                "Pesan\nWarga",
                "/daftar-pesan-warga",
              ),
              _buildMenuItem(
                context,
                Icons.history,
                "Log\nAktivitas",
                "/log-aktivitas",
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
          // Padding luar dikurangi
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start, // Icon nempel atas
            children: [
              Container(
                // PERUBAHAN 2: Padding icon dikurangi jadi 12
                padding: const EdgeInsets.all(12),
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
              // PERUBAHAN 3: Jarak icon ke teks diperkecil jadi 6
              const SizedBox(height: 6),
              Flexible(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10, // Font sedikit lebih jelas
                    height: 1.1,
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