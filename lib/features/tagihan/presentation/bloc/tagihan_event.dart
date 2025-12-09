part of 'tagihan_bloc.dart';

abstract class TagihanEvent extends Equatable {
  const TagihanEvent();

  @override
  List<Object?> get props => [];
}

class LoadTagihanPembayaranList extends TagihanEvent {
  final String? statusFilter;

  const LoadTagihanPembayaranList({this.statusFilter});

  @override
  List<Object?> get props => [statusFilter];
}

class LoadTagihanPembayaranDetail extends TagihanEvent {
  final int id;

  const LoadTagihanPembayaranDetail(this.id);

  @override
  List<Object> get props => [id];
}

class ApproveTagihan extends TagihanEvent {
  final int id;
  final String? catatan;

  const ApproveTagihan({required this.id, this.catatan});

  @override
  List<Object?> get props => [id, catatan];
}

class RejectTagihan extends TagihanEvent {
  final int id;
  final String catatan;

  const RejectTagihan({required this.id, required this.catatan});

  @override
  List<Object> get props => [id, catatan];
}
