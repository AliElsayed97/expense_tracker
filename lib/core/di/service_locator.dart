import 'package:hive_flutter/hive_flutter.dart';

import '../../features/add_expense/data/datasources/add_expense_local_datasource.dart';
import '../../features/add_expense/data/repositories/add_expense_repository_impl.dart';
import '../../features/add_expense/domain/repositories/add_expense_repository.dart';
import '../../features/dashboard/data/datasources/dashboard_local_datasource.dart';
import '../../features/dashboard/data/repositories/dashboard_expense_repository_impl.dart';
import '../../features/dashboard/domain/repositories/dashboard_expense_repository.dart';
import '../persistence/models/expense_hive_model.g.dart';
import '../services/currency_service.dart';

class ServiceLocator {
  static late CurrencyService currencyService;

  static late AddExpenseLocalDataSource addLocal;
  static late AddExpenseRepository addExpenseRepository;

  static late DashboardLocalDataSource dashLocal;
  static late DashboardExpenseRepository dashboardExpenseRepository;

  static Future<void> init() async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(ExpenseHiveModelAdapter());
    }

    currencyService = CurrencyService();

    addLocal = AddExpenseLocalDataSource();
    await addLocal.init();
    addExpenseRepository = AddExpenseRepositoryImpl(
      local: addLocal,
      currencyService: currencyService,
    );

    dashLocal = DashboardLocalDataSource();
    await dashLocal.init();
    dashboardExpenseRepository =
        DashboardExpenseRepositoryImpl(local: dashLocal);
  }
}
