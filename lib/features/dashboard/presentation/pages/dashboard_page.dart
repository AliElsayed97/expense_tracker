// lib/features/dashboard/presentation/pages/dashboard_page.dart
import 'package:expense_tracker_lite/core/utils/media_query_values.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/utils/date_filters.dart'; // contains your ExpenseFilter + extension
import '../../../add_expense/presentation/pages/add_expense_page.dart';
import '../../domain/usecases/get_expenses.dart';
import '../../domain/usecases/get_summary.dart';
import '../bloc/list/expense_list_bloc.dart';
import '../widgets/expense_tile.dart';
import '../widgets/summary_card.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ExpenseListBloc(
        getExpenses: GetExpenses(ServiceLocator.dashboardExpenseRepository),
        getSummary: GetSummary(ServiceLocator.dashboardExpenseRepository),
      )..add(ExpenseListLoaded()),
      child: const _DashboardView(),
    );
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () async {
          final added = await Navigator.of(context).push<bool>(
            MaterialPageRoute(builder: (_) => const AddExpensePage()),
          );
          if (added == true && context.mounted) {
            context.read<ExpenseListBloc>().add(ExpenseListExpenseAdded());
          }
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: AppColors.white),
      ),
      body: SafeArea(
        top: false,
        child: BlocBuilder<ExpenseListBloc, ExpenseListState>(
          builder: (context, state) {
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: AlignmentDirectional.bottomCenter,
                    children: [
                      _header(context, state.filter),
                      Positioned(
                        bottom: -(context.height * 0.05),
                        child: SummaryCard(totalUsd: state.totalUsd),
                      ),
                    ],
                  ),
                ),
                SliverToBoxAdapter(
                    child: SizedBox(height: context.height * 0.08)),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Recent Expenses',
                            style: Theme.of(context).textTheme.titleMedium),
                        Text('see all',
                            style: Theme.of(context).textTheme.titleSmall),
                      ],
                    ),
                  ),
                ),
                if (state.status == ExpenseListStatus.loading ||
                    state.status == ExpenseListStatus.initial)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  )
                else if (state.items.isEmpty)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(child: Text('No expenses yet')),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList.separated(
                      itemCount: state.items.length + 1, // footer
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        if (index < state.items.length) {
                          return ExpenseTile(e: state.items[index]);
                        }

                        if (state.status == ExpenseListStatus.loadingMore) {
                          return const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        if (state.hasMore) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: context.width * 0.1, vertical: 8),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  side: const BorderSide(
                                      color: AppColors.primary, width: 1),
                                ),
                              ),
                              onPressed: () => context
                                  .read<ExpenseListBloc>()
                                  .add(ExpenseListLoadMore()),
                              child: const Text('Load more',
                                  style: TextStyle(color: AppColors.primary)),
                            ),
                          );
                        }

                        return const SizedBox.shrink();
                      },
                    ),
                  ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        backgroundColor: AppColors.white,
        destinations: [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: ''),
          NavigationDestination(
              icon: Icon(Icons.bar_chart_outlined), label: ''),
          NavigationDestination(icon: Icon(Icons.wallet), label: ''),
          NavigationDestination(icon: Icon(Icons.person_outline), label: ''),
        ],
      ),
    );
  }

  Widget _header(BuildContext context, ExpenseFilter filter) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 45.0, 16, context.height * 0.22),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(
        children: [
          const CircleAvatar(
              backgroundImage: AssetImage('assets/avatars/profile.jpg')),
          const SizedBox(width: 12.0),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Good Morning',
                    style: TextStyle(color: AppColors.textOnPrimaryMuted)),
                Text(
                  'Ali Elsayed',
                  style: TextStyle(
                    color: AppColors.textOnPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<ExpenseFilter>(
                value: filter,
                icon: const Icon(Icons.keyboard_arrow_down_outlined),
                dropdownColor: AppColors.white,
                iconEnabledColor: AppColors.black,
                items: ExpenseFilter.values
                    .map((f) => DropdownMenuItem(
                          value: f,
                          child: Text(
                            f.label, // uses your extension
                            style: const TextStyle(
                              color: AppColors.black,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ))
                    .toList(),
                onChanged: (f) {
                  if (f != null) {
                    context
                        .read<ExpenseListBloc>()
                        .add(ExpenseListFilterChanged(f));
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
