import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/broadcast_bloc.dart';

class BroadCastPage extends StatelessWidget {
  const BroadCastPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Broadcast RT')),
      body: BlocBuilder<BroadcastBloc, BroadcastState>(
        builder: (context, state) {
          if (state is BroadcastLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is BroadcastLoaded) {
            return ListView.builder(
              itemCount: state.data.length,
              itemBuilder: (context, index) {
                final item = state.data[index];
                return ListTile(
                  title: Text(item.judul),
                  subtitle: Text(item.isiPesan),
                );
              },
            );
          }

          return const Center(child: Text('Tidak ada data broadcast'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
         
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
