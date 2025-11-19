import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/styles/app_colors.dart';
import '../bloc/add/add_expense_bloc.dart';

class Category {
  final String key;
  final String label;
  final IconData icon;
  final Color color;
  const Category({
    required this.key,
    required this.label,
    required this.icon,
    required this.color,
  });
}

Widget _buildTitle(String text) => Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );

Widget categoriesIconRow(
  AddExpenseState state, {
  VoidCallback? onAddCategory,
  BuildContext? overrideContext,
}) {
  final pastel = <Color>[
    const Color(0xFFEFF6FF),
    const Color(0xFFFFF1FD),
    const Color(0xFFFFFBEB),
    const Color(0xFFF0FDF4),
    const Color(0xFFF5F3FF),
    const Color(0xFFFFF7ED),
    const Color(0xFFFDF2F8),
  ];

  const base = <Category>[
    Category(
      key: 'food',
      label: 'Groceries',
      icon: Icons.local_grocery_store,
      color: Color(0xFF2563EB),
    ),
    Category(
      key: 'entertainment',
      label: 'Entertainment',
      icon: Icons.movie,
      color: Color(0xFFED3ACF),
    ),
    Category(
      key: 'gas',
      label: 'Gas',
      icon: Icons.local_gas_station,
      color: Color(0xFFF59E0B),
    ),
    Category(
      key: 'shopping',
      label: 'Shopping',
      icon: Icons.shopping_bag,
      color: Color(0xFF16A34A),
    ),
    Category(
      key: 'newspaper',
      label: 'News Paper',
      icon: Icons.receipt_long,
      color: Color(0xFF0EA5E9),
    ),
    Category(
      key: 'transport',
      label: 'Transport',
      icon: Icons.emoji_transportation,
      color: Color(0xFF9333EA),
    ),
    Category(
      key: 'rent',
      label: 'Rent',
      icon: Icons.house,
      color: Color(0xFFEA580C),
    ),
  ];

  final items = [
    ...base.asMap().entries.map((e) {
      final idx = e.key % pastel.length;
      final cat = e.value;
      return _CategoryTile(
        keyValue: cat.key,
        label: cat.label,
        icon: cat.icon,
        baseColor: cat.color,
        tint: pastel[idx],
        selected: state.iconKey == cat.key,
        onTap: () {
          overrideContext!.read<AddExpenseBloc>().add(
                AddExpenseFieldChanged(iconKey: cat.key),
              );
        },
      );
    }),
    _CategoryTile(
      keyValue: 'add',
      label: 'Add Category',
      icon: Icons.add,
      baseColor: AppColors.primary,
      tint: Colors.transparent,
      selected: false,
      isAddButton: true,
      onTap: onAddCategory,
    ),
  ];

  // Fixed item width to visually align 4 per row.
  const itemWidth = 70.0;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildTitle('Categories'),
      Wrap(
        spacing: 12,
        runSpacing: 16,
        children: items
            .map(
              (w) => SizedBox(width: itemWidth, child: w),
            )
            .toList(),
      ),
    ],
  );
}

class _CategoryTile extends StatelessWidget {
  final String keyValue;
  final String label;
  final IconData icon;
  final Color baseColor;
  final Color tint;
  final bool selected;
  final bool isAddButton;
  final VoidCallback? onTap;

  const _CategoryTile({
    required this.keyValue,
    required this.label,
    required this.icon,
    required this.baseColor,
    required this.tint,
    required this.selected,
    this.isAddButton = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primary;
    final circleSize = 50.0;

    final bgColor =
        selected ? primary : (isAddButton ? Colors.transparent : tint);
    final iconColor =
        selected ? Colors.white : (isAddButton ? primary : baseColor);

    final border = Border.all(
      color: selected ? primary : (isAddButton ? primary : Colors.black12),
    );

    return GestureDetector(
      onTap: onTap,
      // borderRadius: BorderRadius.circular(999),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: circleSize,
            width: circleSize,
            decoration: BoxDecoration(
              color: bgColor,
              border: border,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(icon, size: 24, color: iconColor),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: selected ? AppColors.primary : Colors.black,
                ),
          ),
        ],
      ),
    );
  }
}
