import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<_OnboardingItem> _items = const [
    _OnboardingItem(
      icon: Icons.account_balance_wallet,
      title: 'Finanzas Personales',
      description: 'Registra tus ingresos y gastos diarios de forma fácil y rápida.',
      color: Colors.green,
    ),
    _OnboardingItem(
      icon: Icons.category,
      title: 'Categorías',
      description: 'Organiza tus gastos por categoría: alimentación, transporte, servicios y más.',
      color: Colors.teal,
    ),
    _OnboardingItem(
      icon: Icons.savings,
      title: 'Presupuestos y Metas',
      description: 'Controla tu dinero con presupuestos mensuales y metas de ahorro.',
      color: Colors.orange,
    ),
    _OnboardingItem(
      icon: Icons.people,
      title: 'Cuentas de Terceros',
      description: 'Lleva el control del dinero que manejas con otras personas: quién te debe y a quién le debes.',
      color: Colors.purple,
    ),
    _OnboardingItem(
      icon: Icons.bar_chart,
      title: 'Dashboard y Reportes',
      description: 'Visualiza gráficos de tu evolución y exporta reportes en PDF.',
      color: Colors.blue,
    ),
  ];

  void _onDone() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_complete', true);
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _items.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final item = _items[index];
                  final screenWidth = MediaQuery.sizeOf(context).width;
                  final padding = screenWidth > 400 ? 40.0 : 24.0;
                  final iconSize = screenWidth > 400 ? 120.0 : 80.0;
                  final iconInnerSize = screenWidth > 400 ? 60.0 : 40.0;
                  return Padding(
                    padding: EdgeInsets.all(padding),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: iconSize,
                          height: iconSize,
                          decoration: BoxDecoration(
                            color: item.color.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            item.icon,
                            size: iconInnerSize,
                            color: item.color,
                          ),
                        ),
                        const SizedBox(height: 40),
                        Text(
                          item.title,
                          style: TextStyle(
                            fontSize: screenWidth > 400 ? 24 : 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          item.description,
                          style: TextStyle(
                            fontSize: screenWidth > 400 ? 16 : 14,
                            color: Colors.grey.shade600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _items.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: FilledButton(
                      onPressed: () {
                        if (_currentPage < _items.length - 1) {
                          _controller.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          _onDone();
                        }
                      },
                      child: Text(
                        _currentPage < _items.length - 1
                            ? 'Siguiente'
                            : 'Empezar',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  if (_currentPage < _items.length - 1)
                    TextButton(
                      onPressed: _onDone,
                      child: const Text('Omitir'),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingItem {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  const _OnboardingItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });
}
