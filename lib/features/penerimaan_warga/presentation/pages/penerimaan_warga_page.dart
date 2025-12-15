import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/penerimaan_warga_bloc.dart';


class PenerimaanWargaPage extends StatelessWidget {
const PenerimaanWargaPage({super.key});


@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(title: const Text('Penerimaan Warga')),
body: BlocBuilder<PenerimaanWargaBloc, PenerimaanWargaState>(
builder: (context, state) {
if (state is PenerimaanWargaLoading) {
return const Center(child: CircularProgressIndicator());
}


if (state is PenerimaanWargaLoaded) {
return ListView.builder(
itemCount: state.data.length,
itemBuilder: (context, index) {
final item = state.data[index];
return ListTile(
title: Text(item.namaPemohon),
subtitle: Text('Status: ${item.status}'),
trailing: const Icon(Icons.arrow_forward_ios),
);
},
);
}


if (state is PenerimaanWargaError) {
return Center(child: Text(state.message));
}


return const SizedBox();
},
),
);
}
}