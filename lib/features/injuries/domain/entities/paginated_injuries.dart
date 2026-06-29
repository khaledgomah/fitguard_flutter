import 'injury_log.dart';

class PaginatedInjuries {
  final List<InjuryLog> injuries;
  final int total;

  const PaginatedInjuries({
    required this.injuries,
    required this.total,
  });
}
