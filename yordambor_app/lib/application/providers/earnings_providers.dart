import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/data/earnings/earnings_repository.dart';
import 'package:yordambor/domain/entities/earnings_row.dart';

final earningsRepositoryProvider = Provider<EarningsRepository>((ref) {
  return EarningsRepository();
});

final earningsRowsProvider = FutureProvider<List<EarningsRow>>((ref) async {
  return ref.watch(earningsRepositoryProvider).fetchAll();
});
