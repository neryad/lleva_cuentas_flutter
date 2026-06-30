import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme_manager.dart';
import 'Home/pages/home_page.dart';
import 'PersonalFinance/pages/personal_finance_page.dart';
import 'Settings/pages/settings_page.dart';
import 'Settings/pages/legal_page.dart';
import 'about/pages/about.dart';
import 'Onboarding/onboarding_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es');
  final themeManager = ThemeManager();

  runApp(
    ChangeNotifierProvider(
      create: (_) => themeManager,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeManager>(
      builder: (context, themeManager, _) {
        return MaterialApp(
          title: 'Lleva Cuentas',
          debugShowCheckedModeBanner: false,
          theme: themeManager.getThemeData(),
          home: const _AppStart(),
          routes: {
            '/settings': (context) => const SettingsPage(),
            '/legal': (context) => const LegalPage(),
            '/about': (context) => const AboutPage(),
          },
        );
      },
    );
  }
}

class _AppStart extends StatefulWidget {
  const _AppStart();

  @override
  State<_AppStart> createState() => _AppStartState();
}

class _AppStartState extends State<_AppStart> {
  bool _loading = true;
  bool _onboardingComplete = false;

  @override
  void initState() {
    super.initState();
    _checkOnboarding();
  }

  void _checkOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _onboardingComplete = prefs.getBool('onboarding_complete') ?? false;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (!_onboardingComplete) {
      return const OnboardingPage();
    }
    return const MainScreen();
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const PersonalFinancePage(),
    const HomePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.account_balance_wallet),
            selectedIcon: Icon(Icons.account_balance_wallet, color: Colors.green),
            label: 'Finanzas',
          ),
          NavigationDestination(
            icon: Icon(Icons.list_alt),
            selectedIcon: Icon(Icons.list_alt, color: Colors.blue),
            label: 'Cuentas',
          ),
        ],
      ),
    );
  }
}
