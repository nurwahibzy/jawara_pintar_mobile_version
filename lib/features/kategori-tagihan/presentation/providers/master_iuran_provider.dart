import 'package:flutter/foundation.dart';
import '../../domain/entities/master_iuran.dart';
import '../../domain/usecases/create_master_iuran.dart';
import '../../domain/usecases/delete_master_iuran.dart';
import '../../domain/usecases/get_master_iuran_by_id.dart';
import '../../domain/usecases/get_master_iuran_by_kategori.dart';
import '../../domain/usecases/get_master_iuran_list.dart';
import '../../domain/usecases/update_master_iuran.dart';

enum MasterIuranStatus { initial, loading, success, error }

class MasterIuranProvider with ChangeNotifier {
  final GetMasterIuranList getMasterIuranList;
  final GetMasterIuranById getMasterIuranById;
  final CreateMasterIuran createMasterIuran;
  final UpdateMasterIuran updateMasterIuran;
  final DeleteMasterIuran deleteMasterIuran;
  final GetMasterIuranByKategori getMasterIuranByKategori;

  MasterIuranProvider({
    required this.getMasterIuranList,
    required this.getMasterIuranById,
    required this.createMasterIuran,
    required this.updateMasterIuran,
    required this.deleteMasterIuran,
    required this.getMasterIuranByKategori,
  });

  List<MasterIuran> _masterIuranList = [];
  MasterIuran? _selectedMasterIuran;
  MasterIuranStatus _status = MasterIuranStatus.initial;
  String _errorMessage = '';

  List<MasterIuran> get masterIuranList => _masterIuranList;
  MasterIuran? get selectedMasterIuran => _selectedMasterIuran;
  MasterIuranStatus get status => _status;
  String get errorMessage => _errorMessage;

  // Get all master iuran
  Future<void> fetchMasterIuranList() async {
    _status = MasterIuranStatus.loading;
    notifyListeners();

    final result = await getMasterIuranList();
    result.fold(
      (failure) {
        _status = MasterIuranStatus.error;
        _errorMessage = failure.message;
        notifyListeners();
      },
      (masterIuranList) {
        _status = MasterIuranStatus.success;
        _masterIuranList = masterIuranList;
        _errorMessage = '';
        notifyListeners();
      },
    );
  }

  // Get master iuran by ID
  Future<void> fetchMasterIuranById(int id) async {
    _status = MasterIuranStatus.loading;
    notifyListeners();

    final result = await getMasterIuranById(id);
    result.fold(
      (failure) {
        _status = MasterIuranStatus.error;
        _errorMessage = failure.message;
        notifyListeners();
      },
      (masterIuran) {
        _status = MasterIuranStatus.success;
        _selectedMasterIuran = masterIuran;
        _errorMessage = '';
        notifyListeners();
      },
    );
  }

  // Create new master iuran
  Future<bool> addMasterIuran(MasterIuran masterIuran) async {
    _status = MasterIuranStatus.loading;
    notifyListeners();

    final result = await createMasterIuran(masterIuran);
    return result.fold(
      (failure) {
        _status = MasterIuranStatus.error;
        _errorMessage = failure.message;
        notifyListeners();
        return false;
      },
      (newMasterIuran) {
        _status = MasterIuranStatus.success;
        _masterIuranList.add(newMasterIuran);
        _errorMessage = '';
        notifyListeners();
        return true;
      },
    );
  }

  // Update master iuran
  Future<bool> editMasterIuran(MasterIuran masterIuran) async {
    _status = MasterIuranStatus.loading;
    notifyListeners();

    final result = await updateMasterIuran(masterIuran);
    return result.fold(
      (failure) {
        _status = MasterIuranStatus.error;
        _errorMessage = failure.message;
        notifyListeners();
        return false;
      },
      (updatedMasterIuran) {
        _status = MasterIuranStatus.success;
        final index = _masterIuranList.indexWhere(
          (item) => item.id == updatedMasterIuran.id,
        );
        if (index != -1) {
          _masterIuranList[index] = updatedMasterIuran;
        }
        _errorMessage = '';
        notifyListeners();
        return true;
      },
    );
  }

  // Delete master iuran
  Future<bool> removeMasterIuran(int id) async {
    _status = MasterIuranStatus.loading;
    notifyListeners();

    final result = await deleteMasterIuran(id);
    return result.fold(
      (failure) {
        _status = MasterIuranStatus.error;
        _errorMessage = failure.message;
        notifyListeners();
        return false;
      },
      (_) {
        _status = MasterIuranStatus.success;
        _masterIuranList.removeWhere((item) => item.id == id);
        _errorMessage = '';
        notifyListeners();
        return true;
      },
    );
  }

  // Get master iuran by kategori
  Future<void> fetchMasterIuranByKategori(int kategoriId) async {
    _status = MasterIuranStatus.loading;
    notifyListeners();

    final result = await getMasterIuranByKategori(kategoriId);
    result.fold(
      (failure) {
        _status = MasterIuranStatus.error;
        _errorMessage = failure.message;
        notifyListeners();
      },
      (masterIuranList) {
        _status = MasterIuranStatus.success;
        _masterIuranList = masterIuranList;
        _errorMessage = '';
        notifyListeners();
      },
    );
  }

  // Clear selected master iuran
  void clearSelectedMasterIuran() {
    _selectedMasterIuran = null;
    notifyListeners();
  }

  // Reset status
  void resetStatus() {
    _status = MasterIuranStatus.initial;
    _errorMessage = '';
    notifyListeners();
  }
}
