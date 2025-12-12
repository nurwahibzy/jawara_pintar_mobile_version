import 'package:flutter/material.dart';

class EmptyBroadcastWidget extends StatelessWidget {
  const EmptyBroadcastWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Belum ada data broadcast",
        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
      ),
    );
  }
}
