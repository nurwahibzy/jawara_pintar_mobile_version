import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../domain/entities/channel_transfer_entities.dart';
import '../../domain/repositories/channel_transfer_repository.dart';
import 'channel_transfer_event.dart';
import 'channel_transfer_state.dart';


class TransferChannelBloc
    extends Bloc<TransferChannelEvent, TransferChannelState> {
  final TransferChannelRepository repository;

  TransferChannelBloc({required this.repository})
    : super(TransferChannelInitial()) {
    on<LoadTransferChannels>(_onLoad);
    on<RefreshTransferChannels>(_onLoad);
    on<DeleteTransferChannelEvent>(_onDelete);
    on<CreateTransferChannelEvent>(_onCreate);
    on<UpdateTransferChannelEvent>(_onUpdate);
  }

  Future<void> _onLoad(TransferChannelEvent event,Emitter<TransferChannelState> emit,) async {
    emit(TransferChannelLoading());

    final Either<Failure, List<TransferChannel>> res = await repository
        .getAllChannels();

    res.fold((failure) => emit(TransferChannelError(failure.message)), (list) {
      if (list.isEmpty) {
        emit(TransferChannelEmpty());
      } else {
        emit(TransferChannelLoaded(list));
      }
    });
  }

  Future<void> _onDelete(
    DeleteTransferChannelEvent event,
    Emitter<TransferChannelState> emit,
  ) async {
    emit(TransferChannelLoading());

    final Either<Failure, bool> res = await repository.deleteChannel(event.id);

    res.fold((failure) => emit(TransferChannelError(failure.message)), (ok) {
      if (ok) {
        add(RefreshTransferChannels());
        emit(const TransferChannelActionSuccess('Hapus berhasil'));
      } else {
        emit(const TransferChannelError('Hapus gagal'));
      }
    });
  }

  Future<void> _onCreate(
    CreateTransferChannelEvent event,
    Emitter<TransferChannelState> emit,
  ) async {
    emit(TransferChannelLoading());

    try {
      final Either<Failure, bool> res = await repository.createChannel(
        event.channel,
        qrFile: event.qrFile,
        thumbnailFile: event.thumbnailFile,
      );

      res.fold((failure) => emit(TransferChannelError(failure.message)), (ok) {
        if (ok) {
          add(RefreshTransferChannels());
          emit(const TransferChannelActionSuccess('Create berhasil'));
        } else {
          emit(const TransferChannelError('Create gagal'));
        }
      });
    } catch (e) {
      emit(TransferChannelError(e.toString()));
    }
  }

  Future<void> _onUpdate(
    UpdateTransferChannelEvent event,
    Emitter<TransferChannelState> emit,
  ) async {
    emit(TransferChannelLoading());

    try {
      final Either<Failure, bool> res = await repository.updateChannel(
        event.channel,
        qrFile: event.qrFile,
        thumbnailFile: event.thumbnailFile,
      );

      res.fold((failure) => emit(TransferChannelError(failure.message)), (ok) {
        if (ok) {
          add(RefreshTransferChannels());
          emit(const TransferChannelActionSuccess('Update berhasil'));
        } else {
          emit(const TransferChannelError('Update gagal'));
        }
      });
    } catch (e) {
      emit(TransferChannelError(e.toString()));
    }
  }
}