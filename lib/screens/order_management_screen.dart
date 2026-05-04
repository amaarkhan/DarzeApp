import 'package:flutter/material.dart';
import '../models/order.dart';
import '../models/customer.dart';
import '../services/db_service.dart';
import '../utils/app_strings.dart';
import 'add_order_screen.dart';

class OrderManagementScreen extends StatefulWidget {
  final String language;

  const OrderManagementScreen({super.key, required this.language});

  @override
  State<OrderManagementScreen> createState() => _OrderManagementScreenState();
}

class _OrderManagementScreenState extends State<OrderManagementScreen> {
  final db = DatabaseService();
  List<Order> orders = [];
  List<Customer> customers = [];
  String filterStatus = 'All';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    final ordersData = await db.getAllOrders();
    final customersData = await db.getAllCustomers();
    setState(() {
      orders = ordersData;
      customers = customersData;
    });
  }

  String _getString(String key) => AppStrings.get(key, widget.language);

  String _getCustomerName(String customerId) {
    try {
      return customers
          .firstWhere((c) => c.id == customerId)
          .name;
    } catch (e) {
      return 'Unknown';
    }
  }

  void _updateOrderStatus(Order order, String newStatus) async {
    final updatedOrder = Order(
      id: order.id,
      customerId: order.customerId,
      clothType: order.clothType,
      orderDate: order.orderDate,
      dueDate: order.dueDate,
      status: newStatus,
      advance: order.advance,
      remaining: order.remaining,
      notes: order.notes,
    );
    await db.updateOrder(updatedOrder);
    _loadData();
    _showSnackBar('Order status updated!');
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.blue.shade600,
      ),
    );
  }

  List<Order> get filteredOrders {
    if (filterStatus == 'All') {
      return orders;
    }
    return orders.where((o) => o.status == filterStatus).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.assignment, size: 28),
            const SizedBox(width: 12),
            Text(
              'Orders',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Filter Chips
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('All', Colors.blue),
                  const SizedBox(width: 8),
                  _buildFilterChip('Pending', Colors.orange),
                  const SizedBox(width: 8),
                  _buildFilterChip('In Progress', Colors.purple),
                  const SizedBox(width: 8),
                  _buildFilterChip('Ready', Colors.teal),
                  const SizedBox(width: 8),
                  _buildFilterChip('Delivered', Colors.green),
                ],
              ),
            ),
          ),

          // Orders List
          Expanded(
            child: filteredOrders.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inbox, size: 64, color: Colors.grey.shade300),
                        const SizedBox(height: 16),
                        Text(
                          'No orders found',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredOrders.length,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemBuilder: (context, index) {
                      final order = filteredOrders[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: _buildOrderCard(order),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddOrderScreen(language: widget.language),
            ),
          ).then((result) {
            if (result == true) {
              _loadData();
            }
          });
        },
        backgroundColor: Colors.blue.shade600,
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }

  Widget _buildFilterChip(String label, Color color) {
    final isSelected = filterStatus == label;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          filterStatus = label;
        });
      },
      backgroundColor: isSelected ? color.withOpacity(0.3) : Colors.grey.shade200,
      selectedColor: color.withOpacity(0.5),
      labelStyle: TextStyle(
        color: isSelected ? color : Colors.grey.shade600,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildOrderCard(Order order) {
    final statusColor = _getStatusColor(order.status);
    final daysUntilDue = order.dueDate.difference(DateTime.now()).inDays;
    final isUrgent = daysUntilDue <= 2 && order.status != 'Delivered';

    return Card(
      elevation: isUrgent ? 4 : 2,
      color: isUrgent ? Colors.red.shade50 : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getCustomerName(order.customerId),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'ID: ${order.customerId}',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        order.clothType,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: statusColor, width: 1),
                  ),
                  child: Text(
                    order.status,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Date and Amount Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order: ${order.orderDate.toString().split(' ')[0]}',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Due: ${order.dueDate.toString().split(' ')[0]}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isUrgent ? Colors.red : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Advance: PKR ${order.advance.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Remaining: PKR ${order.remaining.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.orange,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Status Dropdown
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButton<String>(
                value: order.status,
                items: ['Pending', 'In Progress', 'Ready', 'Delivered']
                    .map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (newStatus) {
                  if (newStatus != null && newStatus != order.status) {
                    _updateOrderStatus(order, newStatus);
                  }
                },
                isExpanded: true,
                underline: const SizedBox(),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              ),
            ),

            // Notes (if any)
            if (order.notes != null && order.notes!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Notes: ${order.notes}',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;
      case 'In Progress':
        return Colors.blue;
      case 'Ready':
        return Colors.purple;
      case 'Delivered':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
