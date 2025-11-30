import 'package:equatable/equatable.dart';

/// Base class untuk Dashboard Kegiatan Events
abstract class DashboardKegiatanEvent extends Equatable {
  const DashboardKegiatanEvent();

  @override
  List<Object> get props => [];
}

/// Event untuk load dashboard kegiatan
class LoadDashboardKegiatanEvent extends DashboardKegiatanEvent {
  const LoadDashboardKegiatanEvent();
}

/// Event untuk refresh dashboard
class RefreshDashboardKegiatanEvent extends DashboardKegiatanEvent {
  const RefreshDashboardKegiatanEvent();
}
