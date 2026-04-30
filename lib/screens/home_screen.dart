import 'package:flutter/material.dart';
import '../services/db_service.dart';
import '../utils/app_strings.dart';
import 'customer_list_screen.dart';
import 'order_management_screen.dart';

class HomeScreen extends StatefulWidget {
  final String language;
  final Function(String) onLanguageChange;

  const HomeScreen({
    Key? key,
    required this.language,
    required this.onLanguageChange,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final db = DatabaseService();
  int totalCustomers = 0;
  int pendingOrders = 0;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  void _loadStats() async {
    final customers = await db.getAllCustomers();
    final orders = await db.getAllOrders();
    final pending =
        orders.where((o) => o.status == 'Pending' || o.status == 'In Progress').length;
    
    setState(() {
      totalCustomers = customers.length;
      pendingOrders = pending;
    });
  }

  String _getString(String key) => AppStrings.get(key, widget.language);

  @override
  Widget build(BuildContext context) {
    final isUrdu = widget.language == 'ur';
    final width = MediaQuery.of(context).size.width;
    final twoColumns = width > 520;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.16),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.storefront_rounded, size: 22),
            ),
            const SizedBox(width: 12),
            Text(
              _getString('app_name'),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade900, Colors.blue.shade700],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ToggleButtons(
              isSelected: [widget.language == 'en', widget.language == 'ur'],
              onPressed: (index) {
                widget.onLanguageChange(index == 0 ? 'en' : 'ur');
              },
              borderRadius: BorderRadius.circular(20),
              constraints: const BoxConstraints(minHeight: 36, minWidth: 64),
              children: const [
                Text('EN'),
                Text('اردو'),
              ],
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _loadStats();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade800, Colors.teal.shade600],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isUrdu ? 'خوش آمدید' : 'Welcome Back',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isUrdu
                            ? 'ایک سادہ جگہ پر کسٹمر اور آرڈر منظم کریں'
                            : 'Manage customers and orders in one simple place.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withOpacity(0.9),
                              height: 1.4,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                
                GridView.count(
                  crossAxisCount: twoColumns ? 2 : 1,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: twoColumns ? 1.9 : 3.8,
                  children: [
                    _buildStatCard(
                      _getString('total_customers'),
                      totalCustomers.toString(),
                      Icons.people_alt_rounded,
                      Colors.blue,
                    ),
                    _buildStatCard(
                      _getString('pending_orders'),
                      pendingOrders.toString(),
                      Icons.assignment_turned_in_rounded,
                      Colors.orange,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    isUrdu ? 'فوری کام' : 'Quick Actions',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  isUrdu
                      ? 'کسٹمر اور آرڈر جلدی کھولیں'
                      : 'Open customers and orders quickly.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 14),
                _buildActionButton(
                  _getString('customers'),
                  Icons.people_alt_rounded,
                  Colors.blue,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CustomerListScreen(language: widget.language),
                      ),
                    ).then((_) => _loadStats());
                  },
                ),
                const SizedBox(height: 12),
                _buildActionButton(
                  _getString('orders'),
                  Icons.receipt_long_rounded,
                  Colors.orange,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            OrderManagementScreen(language: widget.language),
                      ),
                    ).then((_) => _loadStats());
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.16), Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, size: 26, color: color),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    (widget.language == 'ur')
                        ? 'تفصیل دیکھنے یا نیا شامل کرنے کے لیے کھولیں'
                        : 'Open to view, add, and manage records.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}
