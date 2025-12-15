import 'package:flutter/material.dart';

class PenerimaanWargaStatusChip extends StatelessWidget {
  final String status;

  const PenerimaanWargaStatusChip({
    super.key,
    required this.status,
  });

  Color _getColor() {
    switch (status.toLowerCase()) {
      case 'diterima':
        return Colors.green;
      case 'ditolak':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.blueGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        status,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: _getColor(),
      padding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }
}
