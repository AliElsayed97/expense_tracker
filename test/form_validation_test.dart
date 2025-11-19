import 'package:expense_tracker_lite/features/add_expense/presentation/pages/add_expense_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('AddExpensePage amount validator shows error for zero/invalid', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: AddExpensePage()));
    await tester.pumpAndSettle();

    final amountField = find.widgetWithText(TextFormField, 'Amount');
    expect(amountField, findsOneWidget);

    await tester.enterText(amountField, '0');
    await tester.pump();

    final save = find.widgetWithText(FilledButton, 'Save');
    await tester.tap(save);
    await tester.pumpAndSettle();

    expect(find.text('Enter valid amount'), findsOneWidget);
  });
}
