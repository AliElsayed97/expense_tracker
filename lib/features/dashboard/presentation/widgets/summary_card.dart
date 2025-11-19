import 'package:expense_tracker_lite/core/utils/media_query_values.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/styles/app_colors.dart';

class SummaryCard extends StatelessWidget {
  final double totalUsd;
  const SummaryCard({super.key, required this.totalUsd});

  @override
  Widget build(BuildContext context) {
    final f = NumberFormat.simpleCurrency(name: 'USD');
    return Container(
      width: context.width * 0.9,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryAlt,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
              blurRadius: 18,
              color: AppColors.primaryShadow,
              offset: Offset(0, 8))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Balance',
                  style: TextStyle(color: AppColors.textOnPrimaryMuted)),
              Icon(
                Icons.more_horiz,
                color: AppColors.white,
              ),
            ],
          ),
          const SizedBox(height: 6.0),
          Text(f.format(totalUsd),
              style: const TextStyle(
                  color: AppColors.textOnPrimary,
                  fontWeight: FontWeight.w800,
                  fontSize: 28)),
          const SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              _Badge(
                label: 'Income',
                amount: '\$10,840.00',
                icon: Icons.arrow_downward,
              ),
              _Badge(
                label: 'Expenses',
                amount: '\$1,884.00',
                icon: Icons.arrow_upward,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final String amount;
  final IconData icon;
  const _Badge({required this.label, required this.amount, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: AppColors.lightWhite,
              radius: 15.0,
              child: Icon(icon, color: AppColors.textOnPrimary, size: 18),
            ),
            const SizedBox(width: 6.0),
            Text(label,
                style: const TextStyle(
                    fontSize: 16.0, color: AppColors.textOnPrimary)),
          ],
        ),
        const SizedBox(height: 2.0),
        Text(
          amount,
          style: const TextStyle(
            color: AppColors.textOnPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 20.0,
          ),
        ),
      ],
    );
  }
}
