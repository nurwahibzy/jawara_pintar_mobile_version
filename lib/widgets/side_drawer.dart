import 'package:flutter/material.dart';

class SideDrawer extends StatelessWidget {
  const SideDrawer({super.key});

  void _navigateTo(BuildContext context, String routeName) {
    Navigator.pop(context); 
    Navigator.pushNamed(context, routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 50, 16, 20),
            child: Row(
              children: [
                Icon(
                  Icons.book_outlined,
                  size: 32,
                  color: Colors.deepPurple[400],
                ),
                const SizedBox(width: 16),
                const Text(
                  'Jawara Pintar.',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 20.0, top: 10, bottom: 10),
            child: Text(
              'Menu',
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
            ),
          ),
          ExpansionTile(
            leading: const Icon(Icons.dashboard_outlined),
            title: const Text('Dashboard'),
            children: <Widget>[
              _buildSubMenu('Keuangan', context, routeName: '/keuangan'),
              _buildSubMenu('Kegiatan', context, routeName: '/kegiatan'),
              _buildSubMenu(
                'Kependudukan',
                context,
                routeName: '/kependudukan',
              ),
            ],
          ),
          ExpansionTile(
            leading: const Icon(Icons.group_outlined),
            title: const Text('Data Warga & Rumah'),
            children: <Widget>[
              _buildSubMenu('Warga - Daftar', context),
              _buildSubMenu('Warga - Tambah', context),
              _buildSubMenu('Keluarga', context),
              _buildSubMenu('Rumah - Daftar', context),
              _buildSubMenu('Rumah - Tambah', context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubMenu(
    String title,
    BuildContext context, {
    String routeName = '/',
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 26.0), 
      child: ListTile(
        title: Text(title),
        onTap: () {
          _navigateTo(context, routeName);
        },
      ),
    );
  }
}
