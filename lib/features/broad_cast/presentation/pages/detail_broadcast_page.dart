import 'package:flutter/material.dart';
import '../../domain/entities/broadcast.dart';

class DetailBroadCastPage extends StatelessWidget {
  final Broadcast broadcast;

  const DetailBroadCastPage({
    super.key,
    required this.broadcast,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(broadcast.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(broadcast.content),
      ),
    );
  }
}
