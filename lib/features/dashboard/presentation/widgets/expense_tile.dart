import 'package:expense_tracker_lite/core/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/expense.dart';

class ExpenseTile extends StatelessWidget {
  final ExpenseItem e;
  const ExpenseTile({super.key, required this.e});

  @override
  Widget build(BuildContext context) {
    final f = NumberFormat.simpleCurrency(name: e.currency);
    final fUsd = NumberFormat.simpleCurrency(name: 'USD');
    final date = e.date;
    final now = DateTime.now();

    final isToday =
        date.year == now.year && date.month == now.month && date.day == now.day;
    return Card(
      color: AppColors.white,
      child: ListTile(
        leading: getCategory(e.iconKey),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(e.category, style: Theme.of(context).textTheme.titleMedium),
            Text('- ${fUsd.format(e.amountUsd)}',
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(f.format(e.amountOriginal)),
            isToday
                ? Text("Today ${DateFormat('h:mm a').format(date)}")
                : Text(DateFormat.yMMMd().add_jm().format(e.date))
          ],
        ),
      ),
    );
  }

  Widget getCategory(String key) {
    switch (key) {
      case 'food':
        return CircleAvatar(
          backgroundColor: Color(0xFFEFF6FF),
          child: Icon(
            Icons.local_grocery_store,
            color: Color(0xFF2563EB),
          ),
        );
      case 'entertainment':
        return CircleAvatar(
          backgroundColor: Color(0xFFFFF1FD),
          child: Icon(
            Icons.movie_rounded,
            color: Color(0xFFED3ACF),
          ),
        );
      case 'transport':
        return CircleAvatar(
          backgroundColor: Color(0xFFFFF7ED),
          child: Icon(
            Icons.emoji_transportation_outlined,
            color: Color(0xFF9333EA),
          ),
        );
      case 'shopping':
        return CircleAvatar(
          backgroundColor: Color(0xFFF0FDF4),
          child: Icon(
            Icons.shopping_bag_rounded,
            color: Color(0xFF16A34A),
          ),
        );
      case 'rent':
        return CircleAvatar(
          backgroundColor: Color(0xFFFDF2F8),
          child: Icon(
            Icons.house,
            color: Color(0xFFEA580C),
          ),
        );
      case 'gas':
        return CircleAvatar(
          backgroundColor: Color(0xFFFFFBEB),
          child: Icon(
            Icons.local_gas_station,
            color: Color(0xFFF59E0B),
          ),
        );
      case 'newspaper':
        return CircleAvatar(
          backgroundColor: Color(0xFFF5F3FF),
          child: Icon(
            Icons.receipt_long,
            color: Color(0xFF0EA5E9),
          ),
        );
      default:
        return CircleAvatar(child: Icon(Icons.category_rounded));
    }
  }
}
