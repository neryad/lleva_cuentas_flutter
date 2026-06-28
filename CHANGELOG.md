# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
