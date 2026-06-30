import 'package:flutter/material.dart';
import '../../Database/data_base_servie.dart';
import '../../Amount/pages/models/transactions_model.dart';
import '../widgets/summary_card.dart';
import 'presupuestos_page.dart';
import 'metas_ahorro_page.dart';
import 'gastos_recurrentes_page.dart';
import 'personal_dashboard_page.dart';
import 'add_personal_transaction_page.dart';

class PersonalFinancePage extends StatefulWidget {
  const PersonalFinancePage({super.key});

  @override
  State<PersonalFinancePage> createState() => _PersonalFinancePageState();
}

class _PersonalFinancePageState extends State<PersonalFinancePage> {
  final DataBaseHelper _db = DataBaseHelper.instance;
  late int _mesActual;
  late int _anioActual;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _mesActual = now.month;
    _anioActual = now.year;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Finanzas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const PersonalDashboardPage(),
                ),
              );
            },
            tooltip: 'Dashboard',
          ),
        ],
      ),
      body: FutureBuilder<List<Transactions>>(
        future: _db.getPersonalTransactions(mes: _mesActual, anio: _anioActual),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final transactions = snapshot.data ?? [];
          double ingresos = 0;
          double gastos = 0;
          for (var t in transactions) {
            if (t.type == 'Ingreso' || t.type == 'Ahorro') {
              ingresos += t.amount;
            } else {
              gastos += t.amount;
            }
          }
          final balance = ingresos - gastos;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SummaryCard(
                  ingresos: ingresos,
                  gastos: gastos,
                  balance: balance,
                  mes: _mesActual,
                  anio: _anioActual,
                ),
                _buildQuickAccessGrid(context),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'Transacciones recientes',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                if (transactions.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(
                      child: Text(
                        'No hay transacciones este mes',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final t = transactions[index];
                      return _buildTransactionTile(t);
                    },
                  ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddPersonalTransactionPage(),
            ),
          );
          setState(() {});
        },
        icon: const Icon(Icons.add),
        label: const Text('Nueva transacción'),
      ),
    );
  }

  Widget _buildQuickAccessGrid(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        children: [
          _QuickAccessCard(
            icon: Icons.add_circle,
            label: 'Ingreso',
            color: Colors.green,
            onTap: () => _addTransaction('Ingreso'),
          ),
          _QuickAccessCard(
            icon: Icons.remove_circle,
            label: 'Gasto',
            color: Colors.red,
            onTap: () => _addTransaction('Gasto'),
          ),
          _QuickAccessCard(
            icon: Icons.account_balance,
            label: 'Presupuestos',
            color: Colors.orange,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PresupuestosPage()),
            ),
          ),
          _QuickAccessCard(
            icon: Icons.savings,
            label: 'Metas',
            color: Colors.blue,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MetasAhorroPage()),
            ),
          ),
          _QuickAccessCard(
            icon: Icons.repeat,
            label: 'Recurrentes',
            color: Colors.purple,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const GastosRecurrentesPage()),
            ),
          ),
        ],
      ),
    );
  }

  void _addTransaction(String type) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddPersonalTransactionPage(initialType: type),
      ),
    );
    setState(() {});
  }

  Widget _buildTransactionTile(Transactions t) {
    final isIncome = t.type == 'Ingreso' || t.type == 'Ahorro';
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isIncome ? Colors.green.shade100 : Colors.red.shade100,
        child: Icon(
          isIncome ? Icons.arrow_downward : Icons.arrow_upward,
          color: isIncome ? Colors.green : Colors.red,
        ),
      ),
      title: Text(t.comment.isNotEmpty ? t.comment : t.type),
      subtitle: Text(t.date.substring(0, 10)),
      trailing: Text(
        '${isIncome ? '+' : '-'}\$${t.amount.toStringAsFixed(2)}',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: isIncome ? Colors.green : Colors.red,
        ),
      ),
    );
  }
}

class _QuickAccessCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickAccessCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(fontSize: 12, color: color),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
