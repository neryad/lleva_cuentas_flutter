# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.5.0] - 2026-06-30

### Added
- **Personal Finance Module**:
  - Personal transactions (ingresos, gastos, ahorros) separate from accounts
  - Monthly budgets per category with visual progress indicators
  - Savings goals with deadlines and progress tracking
  - Recurring expenses with toggle activation
  - Personal finance dashboard with bar, pie, and line charts
  - PDF export with proper Unicode/Spanish character support (Arial font)
- **Onboarding**:
  - 5-screen interactive onboarding for new users
  - Skippable with "Omitir" button
- **In-App Updates**:
  - Automatic version checking via `upgrader` package
  - Spanish update dialog with "Actualizar" and "Más tarde" options
  - Release notes disabled for cleaner UX
- **Bottom Navigation**:
  - Home screen with "Finanzas" and "Cuentas" tabs
  - Quick access to personal finance and account sections
- **Error Handling**:
  - Centralized error helpers in `error_helpers.dart`
  - Spanish error messages with retry functionality
  - Empty state widgets for better UX
- **Responsiveness**:
  - Adaptive layouts using `LayoutBuilder` for grids
  - `MediaQuery.sizeOf()` for screen size detection
  - `ConstrainedBox(maxWidth: 800)` for large screen content
  - `FittedBox` for font scaling on summary cards
  - `Flexible`/`Expanded` widgets to prevent overflow
- **Database**:
  - Tables: `personal_transactions`, `personal_budgets`, `personal_savings_goals`, `personal_recurring_expenses`
  - Migration from v2 to v3 with `IF NOT EXISTS` for safety
  - `accountId = 0` sentinel for personal transactions

### Changed
- Updated database schema to v3
- Improved transaction card layout with category badges
- Charts now use year-month keys to prevent year collisions
- `DateTime.parse` wrapped in try/catch for robustness
- PDF title now uses month/year parameters instead of generic "Resumen"
- Replaced `MediaQuery.of(context).size` with `MediaQuery.sizeOf(context)`

### Fixed
- Budget spent amount now queries real data instead of hardcoded 0
- MetaAhorro mutation now happens after successful DB save
- Trailing row overflow in summary cards

## [1.4.0] - 2026-06-30

### Added
- Categories system for transactions (17 predefined categories)
- Category model with CRUD operations
- Database migration to v2 with Categories table
- Category selector when creating new transactions
- Category badge display on transaction cards
- Category column in PDF export
- Category distribution chart in Dashboard
- Category management page in Settings (create, edit, delete custom categories)
- Categories organized by type (Ingreso/Gasto/Ahorro)

### Changed
- Updated database schema with categoria_id foreign key
- Improved transaction card layout with category badges

## [1.3.0] - 2026-06-24

### Added
- Dashboard screen with Pie Chart showing distribution by transaction type (Ahorro/Gasto/Ingreso)
- Bar Chart showing monthly comparison of transactions
- Summary card with totals and balance
- `fl_chart` dependency for data visualization
- `getMonthlyTransactions` method in database service
- Navigation button from DetailsPage to Dashboard

### Changed
- Updated README with new dashboard feature
- Version bumped to 1.3.0+17

## [1.2.2] - Previous Release

### Added
- Transaction management (add, edit, delete)
- Account management
- PDF export with QR code
- Dark/Light theme support
- Custom color picker
- Cross-platform support (Android, Web)
