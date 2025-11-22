<div align="center">
  <img src="https://github.com/neryad/lleva_cuentas_flutter/assets/20806101/87a735b6-4e86-401f-9590-a7ee75c7f2c8" alt="Logo de Lleva Cuentas" >
</div>

# Lleva Cuentas [![Codemagic build status](https://api.codemagic.io/apps/660ef805c47054341ffb6c68/660ef805c47054341ffb6c67/status_badge.svg)](https://codemagic.io/apps/660ef805c47054341ffb6c68/660ef805c47054341ffb6c67/latest_build)

[![Built with Flutter](https://img.shields.io/badge/Built_with-Flutter-blue.svg)](https://flutter.dev/)
![Version](https://img.shields.io/badge/Version-1.2.0-blue)
![Build Status](https://img.shields.io/badge/Build-Passing-brightgreen)
![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)
![Platform](https://img.shields.io/badge/Platform-Android%20|%20Web-orange)

Lleva Cuentas is a Flutter-based application designed to help users track their income and expenses. Whether you're managing your personal finances or keeping track of expenses for someone else, Lleva Cuentas provides a simple and intuitive way to record transactions and monitor your financial activity.

## Features

- **Cross-Platform Support**: Available on Android and Web (PWA).
- **Transaction Management**: Easily add, edit, and categorize income and expense transactions.
- **Expense Categories**: Organize transactions into customizable categories for better tracking and analysis.
- **Budget Tracking**: Set monthly budgets for different expense categories and monitor your spending against these budgets.
- **Reports and Analytics**: Generate reports and visualizations to gain insights into your financial habits and trends.
- **Export Options**: Export your transaction data to PDF format (Downloads automatically on Web).
- **Security**: Protect your financial data with password protection and secure storage mechanisms.

## Installation

### Android

To install Lleva Cuentas, simply download it from the [Google Play Store](https://play.google.com/store/apps/details?id=com.neryad.lleva_cuentas).

### Web / IOS [![Netlify Status](https://api.netlify.com/api/v1/badges/e1796715-c9ce-4b18-8926-f8b2b7b93f8e/deploy-status)](https://app.netlify.com/projects/llevacuentas/deploys)

You can access the Web PWA version here: https://llevacuentas.netlify.app/

## Running Locally

1.  **Prerequisites**: Ensure you have Flutter installed and configured.
2.  **Clone the repository**:
    ```bash
    git clone https://github.com/neryad/lleva_cuentas_flutter.git
    ```
3.  **Install dependencies**:
    ```bash
    flutter pub get
    ```
4.  **Run on Chrome**:
    ```bash
    flutter run -d chrome
    ```

## Dependencies

Lleva Cuentas is built using Flutter and utilizes various packages for its functionality. Key dependencies include:

- `sqflite` / `sqflite_common_ffi_web` (Database)
- `pdf` (Document generation)
- `path_provider` (File system access)
- `intl` (Localization)
- `open_filex` (File opening)
- `share_plus` (Sharing content)

For more details, please refer to the `pubspec.yaml` file in the repository.

## Screenshots

![Screenshot 1](https://github.com/neryad/lleva_cuentas_flutter/assets/20806101/266aa419-9607-443b-b717-b90aabd07804)
![Screenshot 2](https://github.com/neryad/lleva_cuentas_flutter/assets/20806101/36a400f8-bb78-4e26-a36b-ab18e8001885)
![Screenshot 3](https://github.com/neryad/lleva_cuentas_flutter/assets/20806101/7c997172-7278-4a17-8c0d-b380bbf2f725)
![Screenshot 4](https://github.com/neryad/lleva_cuentas_flutter/assets/20806101/0c5d720b-c2bf-482e-b735-ccfdba83771e)

## Contributing

Contributions to Lleva Cuentas are welcome! If you encounter any issues or have suggestions for improvement, feel free to submit a pull request or open an issue on the [GitHub repository](https://github.com/neryad/lleva_cuentas_flutter).

## License

Lleva Cuentas is licensed under the MIT License. See the [LICENSE](/LICENSE) file for details.

## Next Steps

Here are some potential next steps and improvements planned for Lleva Cuentas:

- [x] **Migration to Newer Version of Flutter**: Upgrade the app to utilize the latest features and improvements in Flutter, ensuring compatibility and performance enhancements.
- [ ] **Enhanced Budgeting Features**: Implement advanced budgeting features such as custom budget periods, recurring transactions, and expense forecasts.
- [ ] **Improved Reporting**: Enhance reporting capabilities with additional visualization options, customizable report templates, and data export formats.
- [ ] **Localization**: Add support for multiple languages to make the app accessible to a wider audience.

Feel free to contribute ideas or suggestions for further improvement!
