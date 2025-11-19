import 'package:expense_tracker_lite/core/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../../core/di/service_locator.dart';
import '../../domain/entities/expense.dart';
import '../../domain/usecases/add_expense.dart';
import '../bloc/add/add_expense_bloc.dart';
import '../widgets/categories_widget.dart';

class AddExpensePage extends StatelessWidget {
  const AddExpensePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddExpenseBloc(
          addExpense: AddExpense(ServiceLocator.addExpenseRepository)),
      child: const _AddExpenseView(),
    );
  }
}

class _AddExpenseView extends StatefulWidget {
  const _AddExpenseView();

  @override
  State<_AddExpenseView> createState() => _AddExpenseViewState();
}

class _AddExpenseViewState extends State<_AddExpenseView> {
  final _formKey = GlobalKey<FormState>();
  final _amountCtrl = TextEditingController();
  final _picker = ImagePicker();
  final _currencies = const [
    'USD',
    'EUR',
    'GBP',
    'JPY',
    'AED',
    'SAR',
    'EGP',
    'PKR'
  ];

  @override
  void dispose() {
    _amountCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: buildAppBar(context),
      body: buildBody(),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      surfaceTintColor: AppColors.white,
      title: Text('Add Expense',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontSize: 18.0)),
      centerTitle: true,
    );
  }

  Widget buildBody() {
    return SafeArea(
      child: BlocConsumer<AddExpenseBloc, AddExpenseState>(
        listener: (context, state) {
          if (state.status == AddExpenseStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Expense added'),
                behavior: SnackBarBehavior.floating,
                backgroundColor: AppColors.primary,
                duration: Duration(seconds: 2),
              ),
            );

            Navigator.of(context).pop(true);
          } else if (state.status == AddExpenseStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.error ?? 'Error'),
              // backgroundColor: AppColors.primary,
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 20.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ));
          }
        },
        builder: (context, state) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  const SizedBox(height: 12),
                  _categoryDropdown(state),
                  const SizedBox(height: 12),
                  _amountField(),
                  const SizedBox(height: 12),
                  _datePicker(context, state),
                  const SizedBox(height: 12),
                  _currencyDropdown(state),
                  const SizedBox(height: 12),
                  _receiptPicker(context, state),
                  // const SizedBox(height: 20),
                  // _categoriesIconRow(state),
                  const SizedBox(height: 20),
                  categoriesIconRow(state,
                      onAddCategory: () {}, overrideContext: context),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: state.status == AddExpenseStatus.submitting
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              final payload = Expense(
                                category: state.category,
                                iconKey: state.iconKey,
                                amount: state.amount,
                                currency: state.currency,
                                date: state.date,
                                receiptPath: state.receiptPath,
                              );
                              context
                                  .read<AddExpenseBloc>()
                                  .add(AddExpenseSubmitted(payload));
                            }
                          },
                    style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                        backgroundColor:
                            state.status == AddExpenseStatus.submitting
                                ? AppColors.white
                                : AppColors.primary,
                        disabledBackgroundColor: AppColors.white,
                        foregroundColor: AppColors.white,
                        textStyle: Theme.of(context)
                            .textTheme
                            .labelLarge
                            ?.copyWith(fontSize: 16.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0))),
                    child: state.status == AddExpenseStatus.submitting
                        ? CircularProgressIndicator(
                            color: AppColors.primary,
                          )
                        : const Text('Save'),
                  ),
                  const SizedBox(height: 25),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _categoryDropdown(AddExpenseState state) {
    final categories = const [
      'Groceries',
      'Entertainment',
      'Transportation',
      'Shopping',
      'Rent',
      'Gas',
      'News Paper',
      'Other'
    ];
    final iconKeys = const [
      'food',
      'entertainment',
      'transport',
      'shopping',
      'rent',
      'gas',
      'newspaper',
      'other'
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitle('Categories'),
        DropdownButtonFormField<String>(
          value: state.category,
          decoration: _inputDecoration('Categories'),
          icon: Icon(Icons.keyboard_arrow_down_outlined),
          items: List.generate(
              categories.length,
              (i) => DropdownMenuItem(
                  value: categories[i],
                  child: Text(
                    categories[i],
                    style: Theme.of(context).textTheme.bodyMedium,
                  ))),
          onChanged: (v) {
            final idx = categories.indexOf(v ?? 'Entertainment');
            context.read<AddExpenseBloc>().add(
                AddExpenseFieldChanged(category: v, iconKey: iconKeys[idx]));
          },
        ),
      ],
    );
  }

  Widget _amountField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitle('Amount'),
        TextFormField(
          controller: _amountCtrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: _inputDecoration('Amount'),
          validator: (v) {
            final x = double.tryParse(v ?? '');
            if (x == null || x <= 0) return 'Enter valid amount';
            return null;
          },
          onChanged: (v) {
            final x = double.tryParse(v) ?? 0;
            context
                .read<AddExpenseBloc>()
                .add(AddExpenseFieldChanged(amount: x));
          },
        ),
      ],
    );
  }

  Widget _buildTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 1.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }

  Widget _datePicker(BuildContext context, AddExpenseState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitle('Date'),
        InkWell(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: state.date,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (picked != null) {
              context
                  .read<AddExpenseBloc>()
                  .add(AddExpenseFieldChanged(date: picked));
            }
          },
          child: InputDecorator(
            decoration: _inputDecoration('Date'),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(DateFormat.yMMMd().format(state.date)),
                const Icon(Icons.calendar_month),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _currencyDropdown(AddExpenseState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitle('Currency'),
        DropdownButtonFormField<String>(
          value: state.currency,
          icon: Icon(Icons.keyboard_arrow_down_outlined),
          decoration: _inputDecoration('Currency'),
          items: _currencies
              .map((c) => DropdownMenuItem(
                  value: c,
                  child: Text(
                    c,
                    style: Theme.of(context).textTheme.bodyMedium,
                  )))
              .toList(),
          onChanged: (v) => context
              .read<AddExpenseBloc>()
              .add(AddExpenseFieldChanged(currency: v)),
        ),
      ],
    );
  }

  Widget _receiptPicker(BuildContext context, AddExpenseState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitle('Attach Receipt'),
        InkWell(
          onTap: () async {
            final x = await _picker.pickImage(
                source: ImageSource.gallery, imageQuality: 60);
            if (x != null) {
              context
                  .read<AddExpenseBloc>()
                  .add(AddExpenseFieldChanged(receiptPath: x.path));
            }
          },
          child: InputDecorator(
            decoration: _inputDecoration('Attach Receipt'),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    state.receiptPath == null
                        ? 'Upload image'
                        : 'Image selected',
                    style: TextStyle(
                        color: state.receiptPath == null
                            ? AppColors.grey
                            : AppColors.black)),
                Icon(state.receiptPath == null
                    ? Icons.photo_camera_rounded
                    : Icons.attachment_outlined),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Widget _categoriesIconRow(AddExpenseState state) {
  //   final icons = const [
  //     {'key': 'food', 'icon': Icons.local_grocery_store},
  //     {'key': 'entertainment', 'icon': Icons.movie},
  //     {'key': 'transport', 'icon': Icons.emoji_transportation},
  //     {'key': 'shopping', 'icon': Icons.shopping_bag},
  //     {'key': 'rent', 'icon': Icons.house},
  //     {'key': 'gas', 'icon': Icons.local_gas_station},
  //   ];
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       _buildTitle('Categories'),
  //       Wrap(
  //         spacing: 12,
  //         runSpacing: 12,
  //         children: icons
  //             .map((e) => ChoiceChip(
  //                   label: Icon(e['icon'] as IconData),
  //                   selected: state.iconKey == e['key'],
  //                   checkmarkColor: AppColors.primary,
  //                   onSelected: (_) => context.read<AddExpenseBloc>().add(
  //                       AddExpenseFieldChanged(iconKey: e['key'] as String)),
  //                 ))
  //             .toList(),
  //       ),
  //     ],
  //   );
  // }

  InputDecoration _inputDecoration(String hintText) {
    return InputDecoration(
      hint: Text(
        hintText,
        style: TextStyle(color: AppColors.grey),
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.transparent)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.transparent)),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.transparent)),
      filled: true,
      fillColor: AppColors.textFieldFill,
    );
  }
}
