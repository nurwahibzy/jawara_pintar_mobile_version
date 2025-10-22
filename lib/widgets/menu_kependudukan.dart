import 'package:flutter/material.dart';

class MenuKependudukan extends StatelessWidget {
  const MenuKependudukan({super.key});

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
            crossAxisCount: 4, 
            crossAxisSpacing: 12,
            mainAxisSpacing: 16,
            childAspectRatio: 0.85, 
            children: [
              _buildMenuItem(context, Icons.home, "Rumah", '/data-rumah-warga'),
              _buildMenuItem(context, Icons.people, "Warga", '/warga'),
              _buildMenuItem(
                context,
                Icons.card_giftcard,
                "Penerimaan\nWarga",
                '/penerimaan-warga',
              ),
              _buildMenuItem(
                context,
                Icons.swap_horiz,
                "Mutasi\nKeluarga",
                '/mutasi-keluarga',
              ),
              _buildMenuItem(
                context,
                Icons.manage_accounts,
                "Manajemen\nPengguna",
                '/daftar_pengguna',
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
