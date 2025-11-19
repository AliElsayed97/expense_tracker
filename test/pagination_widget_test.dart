import 'package:expense_tracker_lite/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'fakes/fake_expense_repository.dart';
import 'package:expense_tracker_lite/core/di/service_locator.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Dashboard paginates: loads more on scroll to bottom', (tester) async {
    ServiceLocator.dashboardExpenseRepository = FakeExpenseRepository(seedItems: 25);

    await tester.pumpWidget(const MaterialApp(home: DashboardPage()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    final scroll = find.byType(Scrollable).first;

    await tester.fling(scroll, const Offset(0, -600), 1200);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    await tester.fling(scroll, const Offset(0, -600), 1200);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(ListTile), findsAtLeastNWidgets(15));
  });
}
