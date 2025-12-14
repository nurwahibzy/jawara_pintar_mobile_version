import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/tagihan_pembayaran.dart';
import '../bloc/tagihan_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import 'detail_tagihan_pembayaran.dart';

class DaftarTagihanPembayaranPage extends StatefulWidget {
  const DaftarTagihanPembayaranPage({super.key});

  @override
  State<DaftarTagihanPembayaranPage> createState() =>
      _DaftarTagihanPembayaranPageState();
}

class _DaftarTagihanPembayaranPageState
    extends State<DaftarTagihanPembayaranPage> {
  bool _showFilter = false;
  String? _filterStatus;
  String? _filterStatusTemp;

  final formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  final dateFormatter = DateFormat('dd MMM yyyy', 'id_ID');

  @override
  void initState() {
    super.initState();
    context.read<TagihanBloc>().add(const LoadTagihanPembayaranList());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text(
          'Daftar Tagihan Pembayaran',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(
              _showFilter ? Icons.filter_alt : Icons.filter_alt_outlined,
            ),
            onPressed: () {
              setState(() {
                _showFilter = !_showFilter;
                if (!_showFilter) {
                  _filterStatusTemp = _filterStatus;
                }
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (_showFilter) _buildFilterSection(theme),
          Expanded(
            child: BlocConsumer<TagihanBloc, TagihanState>(
              listener: (context, state) {
                if (state is TagihanError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is TagihanLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is TagihanListLoaded) {
                  final tagihanList = state.tagihanList;

                  if (tagihanList.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.inbox_outlined,
                            size: 80,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Belum ada tagihan pembayaran',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<TagihanBloc>().add(
                        LoadTagihanPembayaranList(statusFilter: _filterStatus),
                      );
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: tagihanList.length,
                      itemBuilder: (context, index) {
                        final tagihan = tagihanList[index];
                        return _buildTagihanCard(tagihan, theme);
                      },
                    ),
                  );
                } else {
                  return const Center(child: Text('Gagal memuat data'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DropdownButtonFormField<String>(
            value: _filterStatusTemp,
            decoration: const InputDecoration(
              labelText: 'Status Tagihan',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            items: const [
              DropdownMenuItem(value: null, child: Text('Semua Status')),
              DropdownMenuItem(
                value: 'Belum Lunas',
                child: Text('Belum Lunas'),
              ),
              DropdownMenuItem(value: 'Lunas', child: Text('Lunas')),
            ],
            onChanged: (value) {
              setState(() {
                _filterStatusTemp = value;
              });
            },
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _filterStatus = _filterStatusTemp;
                      _showFilter = false;
                    });
                    context.read<TagihanBloc>().add(
                      LoadTagihanPembayaranList(statusFilter: _filterStatus),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Terapkan'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _filterStatus = null;
                      _filterStatusTemp = null;
                      _showFilter = false;
                    });
                    context.read<TagihanBloc>().add(
                      const LoadTagihanPembayaranList(),
                    );
                  },
                  child: const Text('Reset'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTagihanCard(TagihanPembayaran tagihan, ThemeData theme) {
    Color statusColor;
    IconData statusIcon;

    switch (tagihan.statusVerifikasi) {
      case 'Lunas':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'Belum Lunas':
        statusColor = Colors.orange;
        statusIcon = Icons.pending;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help_outline;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (buildContext) => BlocProvider.value(
                value: BlocProvider.of<TagihanBloc>(context),
                child: DetailTagihanPembayaranPage(tagihanId: tagihan.id),
              ),
            ),
          );
          // Reload list setelah kembali dari detail
          if (mounted) {
            context.read<TagihanBloc>().add(
              LoadTagihanPembayaranList(statusFilter: _filterStatus),
            );
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      tagihan.kodeTagihan ?? '-',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: statusColor),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(statusIcon, size: 16, color: statusColor),
                        const SizedBox(width: 4),
                        Text(
                          tagihan.statusVerifikasi,
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildInfoRow(
                Icons.category_outlined,
                'Iuran',
                tagihan.namaIuran ?? '-',
              ),
              const SizedBox(height: 8),
              _buildInfoRow(
                Icons.calendar_today_outlined,
                'Periode',
                tagihan.periode ?? '-',
              ),
              const SizedBox(height: 8),
              _buildInfoRow(
                Icons.event_outlined,
                'Jatuh Tempo',
                dateFormatter.format(tagihan.tanggalBayar),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Nominal:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      formatter.format(tagihan.nominal ?? 0),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
