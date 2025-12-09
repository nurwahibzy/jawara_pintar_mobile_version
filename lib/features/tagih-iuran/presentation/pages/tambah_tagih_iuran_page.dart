import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/injections/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/master_iuran_dropdown.dart';
import '../bloc/tagih_iuran_bloc.dart';

class TambahTagihIuranPage extends StatelessWidget {
  const TambahTagihIuranPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<TagihIuranBloc>()..add(const LoadMasterIuranDropdown()),
      child: const TambahTagihIuranContent(),
    );
  }
}

class TambahTagihIuranContent extends StatefulWidget {
  const TambahTagihIuranContent({super.key});

  @override
  State<TambahTagihIuranContent> createState() =>
      _TambahTagihIuranContentState();
}

class _TambahTagihIuranContentState extends State<TambahTagihIuranContent> {
  final _formKey = GlobalKey<FormState>();

  MasterIuranDropdown? _selectedMasterIuran;
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  OutlineInputBorder _inputBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: color, width: 1.5),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<TagihIuranBloc, TagihIuranState>(
      listener: (context, state) {
        if (state is TagihIuranLoading) {
          setState(() => _isLoading = true);
        } else {
          setState(() => _isLoading = false);
        }

        if (state is TagihIuranSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true);
        } else if (state is TagihIuranError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tagih Iuran ke Semua Keluarga Aktif'),
          centerTitle: true,
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
        body: Stack(
          children: [
            BlocBuilder<TagihIuranBloc, TagihIuranState>(
              builder: (context, state) {
                List<MasterIuranDropdown> masterIuranList = [];
                if (state is DropdownLoaded) {
                  masterIuranList = state.masterIuranList;
                }

                return Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: ListView(
                      children: [
                        // Info card
                        Card(
                          color: Colors.blue.shade50,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: Colors.blue.shade200),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: Colors.blue.shade700,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Tagihan akan digenerate untuk semua keluarga yang memiliki status aktif',
                                    style: TextStyle(
                                      color: Colors.blue.shade900,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Section Title
                        Text(
                          "Data Tagihan Iuran",
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Dropdown Jenis Iuran dengan Search
                        GestureDetector(
                          onTap: () async {
                            final selected =
                                await showSearch<MasterIuranDropdown>(
                                  context: context,
                                  delegate: _MasterIuranSearchDelegate(
                                    masterIuranList: masterIuranList,
                                    formatRupiah: _formatRupiah,
                                  ),
                                );

                            if (selected != null) {
                              setState(() {
                                _selectedMasterIuran = selected;
                                // Reset tanggal ke hari 1 jika bulanan
                                if (selected.isBulanan) {
                                  _selectedDate = DateTime(
                                    _selectedDate.year,
                                    _selectedDate.month,
                                    1,
                                  );
                                }
                              });
                            }
                          },
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: 'Jenis Iuran *',
                              hintText: 'Pilih jenis iuran',
                              enabledBorder: _inputBorder(theme.dividerColor),
                              focusedBorder: _inputBorder(
                                theme.colorScheme.primary,
                              ),
                              errorBorder: _inputBorder(Colors.red),
                              focusedErrorBorder: _inputBorder(Colors.red),
                              filled: true,
                              fillColor:
                                  theme.inputDecorationTheme.fillColor ??
                                  theme.cardColor,
                              suffixIcon: const Icon(Icons.search),
                            ),
                            child: _selectedMasterIuran == null
                                ? Text(
                                    'Cari dan pilih jenis iuran',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                  )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        _selectedMasterIuran!.namaIuran,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        '${_selectedMasterIuran!.statusTagihan} - ${_formatRupiah(_selectedMasterIuran!.nominalStandar)}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Date Picker
                        InkWell(
                          onTap: () => _selectDate(context),
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: 'Bulan dan Tahun *',
                              enabledBorder: _inputBorder(theme.dividerColor),
                              focusedBorder: _inputBorder(
                                theme.colorScheme.primary,
                              ),
                              filled: true,
                              fillColor:
                                  theme.inputDecorationTheme.fillColor ??
                                  theme.cardColor,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _formatPeriode(_selectedDate),
                                  style: theme.textTheme.bodyMedium,
                                ),
                                Icon(
                                  Icons.calendar_today,
                                  color: Colors.grey[600],
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Info conditional untuk tanggal
                        if (_selectedMasterIuran?.isBulanan == true) ...[
                          const SizedBox(height: 8),
                          Text(
                            'Untuk iuran bulanan, tanggal otomatis diset ke tanggal 1',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],

                        const SizedBox(height: 24),

                        // Submit button
                        ElevatedButton(
                          onPressed: _isLoading
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate() &&
                                      _selectedMasterIuran != null) {
                                    _submitForm(context);
                                  } else if (_selectedMasterIuran == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Pilih jenis iuran terlebih dahulu',
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: Text(
                            'Generate Tagihan',
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: theme.colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            // Loading overlay
            if (_isLoading)
              Container(
                color: Colors.black26,
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final isBulanan = _selectedMasterIuran?.isBulanan ?? false;

    if (isBulanan) {
      // Untuk bulanan, hanya bisa pilih bulan dan tahun
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return _MonthYearPickerDialog(
            initialDate: _selectedDate,
            onDateSelected: (date) {
              setState(() {
                _selectedDate = date;
              });
            },
          );
        },
      );
    } else {
      // Untuk non-bulanan, bisa pilih tanggal lengkap
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(2020),
        lastDate: DateTime(2030),
      );

      if (picked != null && picked != _selectedDate) {
        setState(() {
          _selectedDate = picked;
        });
      }
    }
  }

  void _submitForm(BuildContext context) {
    final periode = DateFormat('yyyy-MM-dd').format(_selectedDate);

    context.read<TagihIuranBloc>().add(
      CreateTagihIuranEvent(
        masterIuranId: _selectedMasterIuran!.id,
        periode: periode,
      ),
    );
  }

  String _formatPeriode(DateTime date) {
    final isBulanan = _selectedMasterIuran?.isBulanan ?? false;

    if (isBulanan) {
      return DateFormat('MMMM yyyy', 'id_ID').format(date);
    } else {
      return DateFormat('dd MMMM yyyy', 'id_ID').format(date);
    }
  }

  String _formatRupiah(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }
}

// Custom Month-Year Picker Dialog
class _MonthYearPickerDialog extends StatefulWidget {
  final DateTime initialDate;
  final Function(DateTime) onDateSelected;

  const _MonthYearPickerDialog({
    required this.initialDate,
    required this.onDateSelected,
  });

  @override
  State<_MonthYearPickerDialog> createState() => _MonthYearPickerDialogState();
}

class _MonthYearPickerDialogState extends State<_MonthYearPickerDialog> {
  late int selectedYear;
  late int selectedMonth;

  @override
  void initState() {
    super.initState();
    selectedYear = widget.initialDate.year;
    selectedMonth = widget.initialDate.month;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Pilih Bulan dan Tahun'),
      content: SizedBox(
        width: 300,
        height: 300,
        child: Column(
          children: [
            // Year selector
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () {
                    setState(() {
                      selectedYear--;
                    });
                  },
                ),
                Text(
                  selectedYear.toString(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () {
                    setState(() {
                      selectedYear++;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Month grid
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: 12,
                itemBuilder: (context, index) {
                  final monthIndex = index + 1;
                  final isSelected = monthIndex == selectedMonth;

                  return InkWell(
                    onTap: () {
                      setState(() {
                        selectedMonth = monthIndex;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          DateFormat(
                            'MMM',
                            'id_ID',
                          ).format(DateTime(2000, monthIndex)),
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onDateSelected(DateTime(selectedYear, selectedMonth, 1));
            Navigator.pop(context);
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}

// Search Delegate untuk Master Iuran
class _MasterIuranSearchDelegate extends SearchDelegate<MasterIuranDropdown> {
  final List<MasterIuranDropdown> masterIuranList;
  final String Function(double) formatRupiah;

  _MasterIuranSearchDelegate({
    required this.masterIuranList,
    required this.formatRupiah,
  }) : super(
         searchFieldLabel: 'Cari jenis iuran...',
         keyboardType: TextInputType.text,
       );

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
          },
        ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, masterIuranList.first);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final results = masterIuranList.where((masterIuran) {
      final queryLower = query.toLowerCase();
      final namaLower = masterIuran.namaIuran.toLowerCase();
      final statusLower = masterIuran.statusTagihan.toLowerCase();

      return namaLower.contains(queryLower) || statusLower.contains(queryLower);
    }).toList();

    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Tidak ada hasil',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              'Coba kata kunci lain',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final masterIuran = results[index];
        return ListTile(
          title: Text(
            masterIuran.namaIuran,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          subtitle: Text(
            '${masterIuran.statusTagihan} - ${formatRupiah(masterIuran.nominalStandar)}',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
          onTap: () {
            close(context, masterIuran);
          },
        );
      },
    );
  }
}
