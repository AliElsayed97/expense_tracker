# Expense Tracker Lite — README

## 1) Overview
Expense Tracker Lite (Flutter) with:
- **BLoC (no Cubit)** across features.
- **Offline-first** storage (Hive).
- **Currency conversion** with **live-first fetch + 6h cache** and **cached fallback**.
- **Pagination** (10/page) + filters (This Month / Last 7 Days / All).
- **First-run offline UX:** saves expense, shows **error snackbar**, USD appears as “—”.

## 2) Key Features
- Live FX fetch **on every conversion**; cache success in Hive `meta` (TTL **6h**).
- On failure/offline: **fresh cache** → **stale cache** → else first-run error.
- Save expense **even if FX fails** (`usdAmount = null`).
- Item row shows: `"{CUR} {amount} • ${usd or —}"`.
- Summary totals in USD (`null` treated as 0).
- Empty/loading/error states; infinite scroll + Load More.



## 3) Folder Structure (Clean architecture)
lib/
├─ core/
│  ├─ di/
│  │  └─ service_locator.dart          # wires both feature repos
│  ├─ services/
│  │  └─ currency_service.dart # fetch+cache USD-based rates + toUsd()
│  ├─ styles/
│  │  ├─ app_colors.dart
│  │  └─ app_theme.dart
│  └─ utils/
│     └─ date_filters.dart             # All | ThisMonth | Last7Days
├─ features/
│  ├─ dashboard/
│  │  ├─ domain/
│  │  │  ├─ entities/
│  │  │  │  └─ expense_item.dart       # read model (shown in lists)
│  │  │  ├─ repositories/
│  │  │  │  └─ dashboard_expense_repository.dart  # interface (+PagedExpenses)
│  │  │  └─ usecases/
│  │  │     ├─ get_expenses.dart
│  │  │     └─ get_summary.dart
│  │  ├─ data/
│  │  │  ├─ datasources/
│  │  │  │  └─ dashboard_local_datasource.dart    # read/paginate from Hive
│  │  │  └─ repositories/
│  │  │     └─ dashboard_expense_repository_impl.dart  # Hive → ExpenseItem
│  │  └─ presentation/
│  │     ├─ bloc/
│  │     │  └─ list/
│  │     │     ├─ expense_list_bloc.dart
│  │     │     ├─ expense_list_event.dart
│  │     │     └─ expense_list_state.dart
│  │     ├─ pages/
│  │     │  └─ dashboard_page.dart
│  │     └─ widgets/
│  │        ├─ expense_tile.dart
│  │        └─ summary_card.dart
│  └─ add_expense/
│     ├─ domain/
│     │  ├─ entities/
│     │  │  └─ new_expense.dart        # write model (form payload)
│     │  ├─ repositories/
│     │  │  └─ add_expense_repository.dart
│     │  └─ usecases/
│     │     └─ add_expense.dart
│     ├─ data/
│     │  ├─ datasources/
│     │  │  └─ add_expense_local_datasource.dart   # write + rates cache (Hive)
│     │  ├─ models/
│     │  │  ├─ expense_hive_model.dart             # shared on-disk schema
│     │  │  └─ expense_hive_model.g.dart           # adapter
│     │  └─ repositories/
│     │     └─ add_expense_repository_impl.dart    # NewExpense → Hive → ExpenseItem
│     └─ presentation/
│        ├─ bloc/
│        │  └─ add/
│        │     ├─ add_expense_bloc.dart
│        │     ├─ add_expense_event.dart
│        │     └─ add_expense_state.dart
│        ├─ pages/
│        │  └─ add_expense_page.dart
│        └─ widgets/
│           └─ categories
└─ main.dart


## 4) State Management (BLoC only)
**Add Expense**
- Event → `AddExpenseSubmitted(draft)`
- Bloc → calls repository.save → success/failure
- UI → on success, show snackbar based on cache/`usdAmount`, then pop

**Dashboard / Expenses**
- Events → `LoadExpenses`, `LoadMoreExpenses`, `ChangeFilter`, `AddRequested`
- State → `Loading` / `Loaded(items, page, hasMore, totalUsd)` / `Error`
- Behavior → filter → sort → paginate (10/page)

## 5) Currency & Caching (must-read)
- Endpoint: `https://open.er-api.com/v6/latest/USD` (no key)
- Policy:
    1. **Try LIVE** each conversion call.
    2. On error/offline → **fresh cache** .
    3. Else → **stale cache** (last good).
    4. Else → throw `NO_RATES_AVAILABLE` (first run + offline).
- Cache keys (Hive `meta`): `rates_json`, `rates_ts`.
- Conversion: API is USD→X, so X→USD = `amount / rate(USD->X)`.

**First-run offline path**: save expense with `usdAmount = null`, show **error snackbar**.

## 6) Install & Run
 - flutter pub get 
 - flutter run
 with flutter version 3.35.2



## 7) Pagination Strategy
- Local paging (Hive): filter → sort desc by date → slice 10/page.
-  scroll + “Load More” button.
- Filters applied **before** paginate.

## 8) Testing
flutter test

Suggested:
- Amount validation (> 0)
- Pagination math (page size 10)
- FX math rationale (USD→X ⇒ X→USD = 1/rate)

## 9) Screenshoot from my device 
![image alt](https://github.com/AliElsayed97/expense_tracker/blob/5387221ae63844310fac720dfa043a732bc54267/1.jpg)

![image alt](https://github.com/AliElsayed97/expense_tracker/blob/5387221ae63844310fac720dfa043a732bc54267/2.jpg) 

![image alt](https://github.com/AliElsayed97/expense_tracker/blob/5387221ae63844310fac720dfa043a732bc54267/3.jpg) 






