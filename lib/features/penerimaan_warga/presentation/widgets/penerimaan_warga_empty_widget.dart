import 'package:flutter/material.dart';

class PenerimaanWargaEmptyWidget extends StatelessWidget {
  const PenerimaanWargaEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.inbox, size: 64, color: Colors.grey),
          SizedBox(height: 12),
          Text(
            'Belum ada data penerimaan warga',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
