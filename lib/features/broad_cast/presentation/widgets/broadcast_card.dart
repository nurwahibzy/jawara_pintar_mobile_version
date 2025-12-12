import 'package:flutter/material.dart';
import '../../domain/entities/broadcast.dart';

class BroadcastCard extends StatelessWidget {
  final Broadcast data;
  final VoidCallback? onTap;

  const BroadcastCard({
    super.key,
    required this.data,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        onTap: onTap,
        title: Text(
          data.judul,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          data.isiPesan,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "${data.tanggalPublikasi.day}/${data.tanggalPublikasi.month}/${data.tanggalPublikasi.year}",
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
