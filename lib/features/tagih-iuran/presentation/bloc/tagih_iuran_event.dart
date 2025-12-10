part of 'tagih_iuran_bloc.dart';

abstract class TagihIuranEvent extends Equatable {
  const TagihIuranEvent();

  @override
  List<Object> get props => [];
}

class LoadMasterIuranDropdown extends TagihIuranEvent {
  const LoadMasterIuranDropdown();
}

class CreateTagihIuranEvent extends TagihIuranEvent {
  final int masterIuranId;
  final String periode;

  const CreateTagihIuranEvent({
    required this.masterIuranId,
    required this.periode,
  });

  @override
  List<Object> get props => [masterIuranId, periode];
}

class ResetTagihIuranState extends TagihIuranEvent {
  const ResetTagihIuranState();
}
