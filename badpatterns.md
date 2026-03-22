# Dart & Flutter — Known Bad Patterns Log

This is a living document. When you catch the AI agent producing bad code, add the pattern here.
The agent MUST check this file before generating code and MUST NOT repeat any pattern listed below.

Format: what the agent did wrong → what it should do instead.

---

## Deprecated APIs

| Bad (deprecated) | Good (current) | Since |
|---|---|---|
| `FlatButton` | `TextButton` | Flutter 2.0 |
| `RaisedButton` | `ElevatedButton` | Flutter 2.0 |
| `OutlineButton` | `OutlinedButton` | Flutter 2.0 |
| `WillPopScope` | `PopScope` | Flutter 3.16 |
| `MaterialStateProperty` | `WidgetStateProperty` | Flutter 3.22 |
| `MaterialStateColor` | `WidgetStateColor` | Flutter 3.22 |
| `Theme.of(context).accentColor` | `Theme.of(context).colorScheme.secondary` | Flutter 2.0 |
| `Theme.of(context).backgroundColor` | `Theme.of(context).colorScheme.surface` | Flutter 3.3 |
| `RawKeyboardListener` | `KeyboardListener` | Flutter 3.18 |
| `WidgetsBinding.instance!` | `WidgetsBinding.instance` (non-nullable since 3.0) | Flutter 3.0 |

When you encounter a deprecation not listed here — add it.

---

## Caught Patterns

<!--
Copy this template to log new patterns:

### PATTERN-NNN: Short title
- **Date caught:** YYYY-MM-DD
- **Bad code:**
  ```dart
  // what the agent generated
  ```
- **Correct code:**
  ```dart
  // what it should have generated
  ```
- **Rule violated:** (e.g., "Effective Dart Usage", "SRP", "null safety")
-->

### PATTERN-001: Bang operator instead of null handling

- **Date caught:** —
- **Bad code:**
  ```dart
  final user = snapshot.data!;
  ```
- **Correct code:**
  ```dart
  final user = snapshot.data;
  if (user == null) return const SizedBox.shrink();
  ```
- **Rule violated:** Null safety

### PATTERN-002: Helper methods instead of widget classes

- **Date caught:** —
- **Bad code:**
  ```dart
  Widget _buildHeader() {
    return Container(...);
  }
  ```
- **Correct code:**
  ```dart
  class _Header extends StatelessWidget {
    const _Header();
    @override
    Widget build(BuildContext context) => Container(...);
  }
  ```
- **Rule violated:** SRP, Flutter rebuild optimization

### PATTERN-003: Missing dispose

- **Date caught:** —
- **Bad code:**
  ```dart
  class _MyState extends State<MyWidget> {
    final controller = TextEditingController();
    // no dispose()
  }
  ```
- **Correct code:**
  ```dart
  class _MyState extends State<MyWidget> {
    final controller = TextEditingController();

    @override
    void dispose() {
      controller.dispose();
      super.dispose();
    }
  }
  ```
- **Rule violated:** Resource management

### PATTERN-004: setState after async gap without mounted check

- **Date caught:** —
- **Bad code:**
  ```dart
  Future<void> _load() async {
    final data = await fetchData();
    setState(() => _data = data);
  }
  ```
- **Correct code:**
  ```dart
  Future<void> _load() async {
    final data = await fetchData();
    if (!mounted) return;
    setState(() => _data = data);
  }
  ```
- **Rule violated:** Widget lifecycle safety

### PATTERN-005: Business logic in build method

- **Date caught:** —
- **Bad code:**
  ```dart
  @override
  Widget build(BuildContext context) {
    final filtered = items.where((i) => i.price > 100).toList()
      ..sort((a, b) => b.rating.compareTo(a.rating));
    final total = filtered.fold(0.0, (sum, i) => sum + i.price);
    // ... renders UI with filtered and total
  }
  ```
- **Correct code:**
  ```dart
  // Move to BLoC/Cubit/ViewModel. Widget just reads the result.
  ```
- **Rule violated:** SRP, separation of concerns

### PATTERN-006: StatefulWidget when StatelessWidget suffices

- **Date caught:** —
- **Bad code:**
  ```dart
  class ProfileCard extends StatefulWidget { ... }
  class _ProfileCardState extends State<ProfileCard> {
    // no initState, no setState, no controllers — just build()
  }
  ```
- **Correct code:**
  ```dart
  class ProfileCard extends StatelessWidget {
    const ProfileCard({super.key});
    // ...
  }
  ```
- **Rule violated:** KISS, Flutter conventions

### PATTERN-007: Mutable state classes

- **Date caught:** —
- **Bad code:**
  ```dart
  class DashboardState {
    List<Item> items = [];
    bool isLoading = false;
  }
  ```
- **Correct code:**
  ```dart
  class DashboardState extends Equatable {
    const DashboardState({this.items = const [], this.isLoading = false});
    final List<Item> items;
    final bool isLoading;
    DashboardState copyWith({List<Item>? items, bool? isLoading}) => ...;
    @override
    List<Object?> get props => [items, isLoading];
  }
  ```
- **Rule violated:** Immutable state, Equatable for BLoC

### PATTERN-008: ListView inside Column without constraints

- **Date caught:** —
- **Bad code:**
  ```dart
  Column(children: [Text('Header'), ListView(...)])
  ```
- **Correct code:**
  ```dart
  Column(children: [Text('Header'), Expanded(child: ListView(...))])
  ```
- **Rule violated:** Flutter layout constraints

---

## How to Use This File

1. When reviewing AI-generated code, check against this list first.
2. When you catch a new bad pattern, copy the template and add it.
3. Increment the pattern number.
4. Reference the rule it violates so patterns stay linked to principles.
5. Periodically review: if a pattern stops appearing, it's working.
