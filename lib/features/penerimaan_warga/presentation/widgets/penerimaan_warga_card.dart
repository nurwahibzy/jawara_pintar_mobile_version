import 'package:flutter/material.dart';
import '../../domain/entities/penerimaan_warga.dart';
import 'penerimaan_warga_status_chip.dart';

class PenerimaanWargaCard extends StatelessWidget {
  final PenerimaanWarga data;
  final VoidCallback? onTap;

  const PenerimaanWargaCard({
    super.key,
    required this.data,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      child: ListTile(
        onTap: onTap,
        leading: const Icon(Icons.person, size: 32),
        title: Text(
          data.namaPemohon,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("NIK: ${data.nik}"),
            const SizedBox(height: 4),
            PenerimaanWargaStatusChip(status: data.status),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
