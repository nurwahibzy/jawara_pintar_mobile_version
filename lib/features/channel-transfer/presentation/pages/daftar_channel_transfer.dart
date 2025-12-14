import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/channel_transfer_entities.dart';
import '../bloc/channel_transfer_bloc.dart';
import '../bloc/channel_transfer_event.dart';
import '../bloc/channel_transfer_state.dart';
import 'detail_channel_transfer.dart';
import 'edit_channel_transfer.dart';

class DaftarTransferChannel extends StatefulWidget {
  const DaftarTransferChannel({super.key});

  @override
  State<DaftarTransferChannel> createState() => _DaftarTransferChannelState();
}

class _DaftarTransferChannelState extends State<DaftarTransferChannel> {
  bool _showFilter = false;
  final TextEditingController _searchController = TextEditingController();

  String? _filterTipe;
  String? _filterTipeTemp;
  String? _filterSearchTemp;
  DateTime? _filterDari;
  DateTime? _filterSampai;
  DateTime? _filterDariTemp;
  DateTime? _filterSampaiTemp;

  List<TransferChannel> _allChannels = [];
  final formatter = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    context.read<TransferChannelBloc>().add(LoadTransferChannels());
  }

  List<TransferChannel> get filteredChannels {
    return _allChannels.where((channel) {
      final searchMatch = channel.namaChannel.toLowerCase().contains(
        _searchController.text.toLowerCase(),
      );

      final tipeMatch = _filterTipe == null || _filterTipe == '-- Pilih Tipe --'
          ? true
          : channel.tipe.name == _filterTipe;

    final dariMatch = _filterDari == null
          ? true
          : channel.createdAt?.isAfter(
                  _filterDari!.subtract(const Duration(days: 1)),
                ) ??
                false;

      final sampaiMatch = _filterSampai == null
          ? true
          : channel.createdAt?.isBefore(
                  _filterSampai!.add(const Duration(days: 1)),
                ) ??
                false;

      return searchMatch && tipeMatch && dariMatch && sampaiMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final tipeOptions = [
      '-- Pilih Tipe --',
      ...ChannelType.values.map((e) => e.name),
    ];

    return Scaffold(
     appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text(
          'Transfer Channels',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        actions: [
          IconButton(
            icon: Icon(
              _showFilter ? Icons.filter_alt_off : Icons.filter_alt,
              color: Colors.white,
            ),
            onPressed: () => setState(() => _showFilter = !_showFilter),
          ),
        ],
      ),
      body: Column(
        children: [
          // FILTER PANEL
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            crossFadeState: _showFilter
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: Padding(
              padding: const EdgeInsets.all(12),
              child: Card(
                color: Colors.white,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Filter',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: Colors.black87,
                            ),
                            onPressed: () =>
                                setState(() => _showFilter = false),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Cari nama channel...',
                          prefixIcon: const Icon(Icons.search),
                          filled: true,
                          fillColor: AppColors.secondBackground,
                        ),
                        onChanged: (v) => _filterSearchTemp = v,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: AppColors.secondBackground,
                        ),
                        initialValue: _filterTipe ?? '-- Pilih Tipe --',
                        items: tipeOptions
                            .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)),
                            )
                            .toList(),
                        onChanged: (v) => setState(() => _filterTipeTemp = v),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                final picked = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime.now(),
                                );
                                if (picked != null) {
                                  setState(() => _filterDariTemp = picked);
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.secondBackground,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  _filterDariTemp == null
                                      ? "Dari Tanggal"
                                      : formatter.format(_filterDariTemp!),
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                final picked = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime.now(),
                                );
                                if (picked != null) {
                                  setState(() => _filterSampaiTemp = picked);
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.secondBackground,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  _filterSampaiTemp == null
                                      ? "Sampai Tanggal"
                                      : formatter.format(_filterSampaiTemp!),
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton(
                            onPressed: () {
                              setState(() {
                                _searchController.clear();
                                _filterTipe = '-- Pilih Tipe --';
                                _filterDari = null;
                                _filterSampai = null;
                                _filterSearchTemp = null;
                                _filterTipeTemp = null;
                                _filterDariTemp = null;
                                _filterSampaiTemp = null;
                              });
                            },
                            child: const Text("Reset Filter"),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _filterTipe = _filterTipeTemp;
                                _searchController.text =
                                    _filterSearchTemp ?? "";
                                _filterDari = _filterDariTemp;
                                _filterSampai = _filterSampaiTemp;
                              });
                            },
                            child: const Text("Terapkan"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            secondChild: const SizedBox.shrink(),
          ),
          const Divider(),
          // LIST AREA
          Expanded(
            child: BlocConsumer<TransferChannelBloc, TransferChannelState>(
              listener: (context, state) {
                if (state is TransferChannelError) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                } else if (state is TransferChannelActionSuccess) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                  context.read<TransferChannelBloc>().add(
                    LoadTransferChannels(),
                  );
                } else if (state is TransferChannelLoaded) {
                  _allChannels = state.channels;
                  setState(() {});
                }
              },
              builder: (context, state) {
                if (state is TransferChannelLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is TransferChannelEmpty) {
                  return const Center(child: Text('Belum ada channel'));
                }

                final list = filteredChannels;
                if (list.isEmpty) {
                  return const Center(
                    child: Text('Belum ada channel yang cocok'),
                  );
                }

               return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final channel = list[index];
                    return Card(
                      child: ListTile(
                        title: Text(channel.namaChannel),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.category,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 4),
                                Text(channel.tipe.name),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  channel.createdAt != null
                                      ? formatter.format(channel.createdAt!)
                                      : '-',
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'detail') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DetailTransferChannelPage(
                                    channel: channel,
                                  ),
                                ),
                              );
                            } else if (value == 'edit') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BlocProvider.value(
                                    value: context.read<TransferChannelBloc>(),
                                    child: EditTransferChannelPage(
                                      channel: channel,
                                    ),
                                  ),
                                ),
                              );
                            } else if (value == 'hapus') {
                              context.read<TransferChannelBloc>().add(
                                DeleteTransferChannelEvent(channel.id!),
                              );
                            }
                          },
                          itemBuilder: (_) => const [
                            PopupMenuItem(
                              value: 'detail',
                              child: Text("Detail"),
                            ),
                            PopupMenuItem(value: 'edit', child: Text("Edit")),
                            PopupMenuItem(value: 'hapus', child: Text("Hapus")),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary, 
        foregroundColor: Colors.white, 
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.pushNamed(
            context,
            '/tambah-channel-transfer',
          );
          if (result == true) {
            context.read<TransferChannelBloc>().add(LoadTransferChannels());
          }
        },
      ),
    );
  }
}