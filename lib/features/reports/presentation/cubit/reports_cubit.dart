import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../dashboard/data/repositories/dashboard_repository.dart';
import 'reports_state.dart';

class ReportsCubit extends Cubit<ReportsState> {
  final DashboardRepository repository;

  ReportsCubit({required this.repository}) : super(ReportsInitial());

  Future<void> fetchReports() async {
    emit(ReportsLoading());
    try {
      final stats = await repository.getStats();
      emit(ReportsLoaded(stats));
    } catch (e) {
      emit(ReportsError(e.toString()));
    }
  }
}
