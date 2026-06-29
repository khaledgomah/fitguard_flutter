import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/dashboard_repository.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit({required DashboardRepository dashboardRepository})
      : _dashboardRepository = dashboardRepository,
        super(DashboardInitial());

  final DashboardRepository _dashboardRepository;

  Future<void> fetchDashboardStats() async {
    emit(DashboardLoading());
    try {
      final stats = await _dashboardRepository.getStats();
      emit(DashboardLoaded(stats));
    } catch (e) {
      emit(DashboardError(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
