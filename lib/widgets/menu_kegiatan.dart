import 'package:flutter/material.dart';

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
            childAspectRatio: 0.85, // Lebih tinggi untuk memberi ruang label
            children: [
              _buildMenuItem(
                context,
                Icons.event,
                "Daftar\nKegiatan",
                "/daftar-kegiatan",
              ),
              _buildMenuItem(
                context,
                Icons.message,
                "Pesan\nWarga",
                "/pesan-warga",
              ),
              _buildMenuItem(
                context,
                Icons.campaign,
                "Broadcast",
                "/broadcast",
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
              color: Color(0xff8E6CEF).withAlpha(20),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Color(0xff8E6CEF), size: 28),
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
