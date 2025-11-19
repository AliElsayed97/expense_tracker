import 'package:hive/hive.dart';
import '../../../../core/persistence/hive_boxes.dart';
import '../../../../core/persistence/models/expense_hive_model.dart';

class AddExpenseLocalDataSource {
  late Box<ExpenseHiveModel> _box;

  Future<void> init() async {
    _box = await Hive.openBox<ExpenseHiveModel>(HiveBoxes.expenses);
  }

  Future<void> add(ExpenseHiveModel model) async {
    await _box.put(model.id, model);
  }
}
