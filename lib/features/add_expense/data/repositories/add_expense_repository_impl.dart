import 'package:uuid/uuid.dart';

import '../../../../core/persistence/models/expense_hive_model.dart';
import '../../../../core/services/currency_service.dart';
import '../../../dashboard/domain/entities/expense.dart' as dashboard;
import '../../domain/entities/expense.dart';
import '../../domain/repositories/add_expense_repository.dart';
import '../datasources/add_expense_local_datasource.dart';

class AddExpenseRepositoryImpl implements AddExpenseRepository {
  final AddExpenseLocalDataSource local;
  final CurrencyService currencyService;

  AddExpenseRepositoryImpl({
    required this.local,
    required this.currencyService,
  });

  @override
  Future<dashboard.ExpenseItem> add(Expense expense) async {
    final String id = const Uuid().v4();

    // Will return fresh/cached rates. Throws only when first run + offline (no cache).
    final rates = await currencyService.getUsdRates();

    final amountUsd = currencyService.toUsd(
      amount: expense.amount,
      currency: expense.currency,
      usdBaseRates: rates,
    );

    final model = ExpenseHiveModel(
      id: id,
      category: expense.category,
      iconKey: expense.iconKey,
      amountOriginal: expense.amount,
      currency: expense.currency,
      amountUsd: amountUsd,
      date: expense.date,
      receiptPath: expense.receiptPath,
    );

    await local.add(model);

    return dashboard.ExpenseItem(
      id: model.id,
      category: model.category,
      iconKey: model.iconKey,
      amountOriginal: model.amountOriginal,
      currency: model.currency,
      amountUsd: model.amountUsd,
      date: model.date,
      receiptPath: model.receiptPath,
    );
  }
}
