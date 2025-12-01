import 'package:flutter/material.dart';

class BroadCastPage extends StatelessWidget {
  const BroadCastPage({super.key});

  static const String routeName = '/broad_cast';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BroadCast')),
      body: const Center(child: Text('BroadCast Page')),
    );
  }
}
