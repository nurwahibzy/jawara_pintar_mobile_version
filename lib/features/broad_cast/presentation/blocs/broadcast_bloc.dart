import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jawara_pintar_mobile_version/features/broad_cast/domain/use_cases/add_broadcast.dart';
import 'package:jawara_pintar_mobile_version/features/broad_cast/domain/use_cases/get_broadcast_list.dart';
import '../../domain/entities/broadcast.dart';


// --- EVENTS ---
abstract class BroadcastEvent {}


class LoadBroadcastEvent extends BroadcastEvent {}


class AddBroadcastEvent extends BroadcastEvent {
final Broadcast data;
AddBroadcastEvent(this.data);
}


// --- STATES ---
abstract class BroadcastState {}


class BroadcastInitial extends BroadcastState {}


class BroadcastLoading extends BroadcastState {}


class BroadcastLoaded extends BroadcastState {
final List<Broadcast> data;
BroadcastLoaded(this.data);
}


class BroadcastError extends BroadcastState {
final String message;
BroadcastError(this.message);
}


// --- BLOC ---
class BroadcastBloc extends Bloc<BroadcastEvent, BroadcastState> {
final GetBroadcastUseCase getBroadcast;
final AddBroadcastUseCase addBroadcast;


BroadcastBloc(this.getBroadcast, this.addBroadcast)
: super(BroadcastInitial()) {
on<LoadBroadcastEvent>((event, emit) async {
emit(BroadcastLoading());
try {
final data = await getBroadcast();
emit(BroadcastLoaded(data));
} catch (e) {
emit(BroadcastError(e.toString()));
}
});


on<AddBroadcastEvent>((event, emit) async {
try {
await addBroadcast(event.data);
add(LoadBroadcastEvent());
} catch (e) {
emit(BroadcastError(e.toString()));
}
});
}
}