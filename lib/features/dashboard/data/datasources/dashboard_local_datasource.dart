import 'package:hive/hive.dart';
import '../../../../core/utils/date_filters.dart';
import '../../../../core/persistence/hive_boxes.dart';
import '../../../../core/persistence/models/expense_hive_model.dart';

class DashboardLocalDataSource {
  late Box<ExpenseHiveModel> _box;

  Future<void> init() async {
    _box = await Hive.openBox<ExpenseHiveModel>(HiveBoxes.expenses);
  }

  Future<List<ExpenseHiveModel>> query(
    ExpenseFilter filter, {
    required int page,
    required int pageSize,
  }) async {
    final all = _box.values.toList()..sort((a, b) => b.date.compareTo(a.date));
    final filtered = all.where((e) => filter.includeDate(e.date)).toList();
    final start = page * pageSize;
    final end = (start + pageSize).clamp(0, filtered.length).toInt();
    if (start >= filtered.length) return <ExpenseHiveModel>[];
    return filtered.sublist(start, end);
  }

  Future<double> sumUsd(ExpenseFilter filter) async {
    final all = _box.values.where((e) => filter.includeDate(e.date));
    return all.fold<double>(0.0, (p, e) => p + e.amountUsd);
  }

  Future<int> countFiltered(ExpenseFilter filter) async {
    return _box.values.where((e) => filter.includeDate(e.date)).length;
  }
}
