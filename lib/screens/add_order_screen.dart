import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/order.dart';
import '../models/customer.dart';
import '../services/db_service.dart';

class AddOrderScreen extends StatefulWidget {
  final String language;
  final Order? order;

  const AddOrderScreen({
    Key? key,
    required this.language,
    this.order,
  }) : super(key: key);

  @override
  State<AddOrderScreen> createState() => _AddOrderScreenState();
}

class _AddOrderScreenState extends State<AddOrderScreen> {
  final db = DatabaseService();
  late TextEditingController advanceController;
  late TextEditingController remainingController;
  late TextEditingController notesController;
  late TextEditingController customerSearchController;
  late bool isUrdu;
  
  String? selectedCustomerId;
  String selectedClothType = 'Shalwar Kameez (Gents)';
  String selectedStatus = 'Pending';
  DateTime dueDate = DateTime.now().add(const Duration(days: 7));
  List<Customer> customers = [];
  List<Customer> filteredCustomers = [];

  @override
  void initState() {
    super.initState();
    isUrdu = widget.language == 'ur';
    advanceController = TextEditingController(text: widget.order?.advance.toString() ?? '');
    remainingController = TextEditingController(text: widget.order?.remaining.toString() ?? '');
    notesController = TextEditingController(text: widget.order?.notes ?? '');
    customerSearchController = TextEditingController();
    selectedStatus = widget.order?.status ?? 'Pending';
    selectedClothType = widget.order?.clothType ?? 'Shalwar Kameez (Gents)';
    dueDate = widget.order?.dueDate ?? DateTime.now().add(const Duration(days: 7));
    _loadCustomers();
    customerSearchController.addListener(_filterCustomers);
  }

  void _loadCustomers() async {
    final data = await db.getAllCustomers();
    setState(() {
      customers = data;
      filteredCustomers = data;
      if (widget.order != null) {
        selectedCustomerId = widget.order!.customerId;
      } else if (customers.isNotEmpty) {
        selectedCustomerId = customers.first.id;
      }
    });
  }

  void _filterCustomers() {
    final query = customerSearchController.text.toLowerCase().trim();
    setState(() {
      if (query.isEmpty) {
        filteredCustomers = customers;
      } else {
        filteredCustomers = customers.where((customer) {
          return customer.name.toLowerCase().contains(query) ||
              customer.phone.toLowerCase().contains(query);
        }).toList();
      }

      if (selectedCustomerId != null &&
          !filteredCustomers.any((customer) => customer.id == selectedCustomerId)) {
        if (filteredCustomers.isNotEmpty) {
          selectedCustomerId = filteredCustomers.first.id;
        }
      }
    });
  }

  Future<void> _selectDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        dueDate = picked;
      });
    }
  }

  Future<void> _saveOrder() async {
    if (selectedCustomerId == null || 
        advanceController.text.isEmpty || 
        remainingController.text.isEmpty) {
      _showSnackBar('Please fill all required fields');
      return;
    }

    try {
      final order = Order(
        id: widget.order?.id ?? const Uuid().v4(),
        customerId: selectedCustomerId!,
        clothType: selectedClothType,
        orderDate: widget.order?.orderDate ?? DateTime.now(),
        dueDate: dueDate,
        status: selectedStatus,
        advance: double.parse(advanceController.text),
        remaining: double.parse(remainingController.text),
        notes: notesController.text.trim(),
      );

      await db.addOrder(order);
      _showSnackBar('Order saved successfully!');
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pop(context, true);
      });
    } catch (e) {
      _showSnackBar('Error: $e');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.blue.shade600,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isUrdu = widget.language == 'ur';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.order == null
              ? (isUrdu ? 'نیا آرڈر' : 'Add New Order')
              : (isUrdu ? 'آرڈر میں ترمیم' : 'Edit Order'),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade900, Colors.orange.shade700],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Information Section
            _buildSectionTitle(isUrdu ? 'آرڈر کی معلومات' : 'Order Information'),
            const SizedBox(height: 16),

            // Customer Selection
            if (customers.isNotEmpty)
              Column(
                children: [
                  TextField(
                    controller: customerSearchController,
                    decoration: InputDecoration(
                      labelText: isUrdu ? 'کسٹمر تلاش کریں' : 'Search customer',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: selectedCustomerId,
                    items: filteredCustomers.map((customer) {
                      return DropdownMenuItem(
                        value: customer.id,
                        child: Text('${customer.name} - ${customer.phone}'),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedCustomerId = newValue;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: isUrdu ? 'کسٹمر منتخب کریں' : 'Select Customer',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                    ),
                  ),
                ],
              )
            else
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.shade50,
                ),
                child: Text(isUrdu ? 'کوئی کسٹمر موجود نہیں۔ پہلے کسٹمر شامل کریں۔' : 'No customers available. Add a customer first.'),
              ),

            const SizedBox(height: 12),

            // Clothing Type
            DropdownButtonFormField<String>(
              value: selectedClothType,
              items: [
                'Shalwar Kameez (Gents)',
                'Shalwar Kameez (Ladies)',
                'Shirt',
                'Pant/Trouser',
                'Sherwani',
                'Coat/Suit',
                'Custom'
              ].map((type) {
                return DropdownMenuItem(value: type, child: Text(type));
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedClothType = newValue ?? 'Shalwar Kameez (Gents)';
                });
              },
              decoration: InputDecoration(
                labelText: isUrdu ? 'کپڑے کی قسم' : 'Clothing Type',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
            ),

            const SizedBox(height: 24),

            // Payment Information
            _buildSectionTitle(isUrdu ? 'ادائیگی کی تفصیل' : 'Payment Details'),
            const SizedBox(height: 16),

            _buildTextField(advanceController, isUrdu ? 'ایڈوانس رقم (روپے)' : 'Advance Payment (PKR)', Icons.attach_money),
            const SizedBox(height: 12),
            _buildTextField(remainingController, isUrdu ? 'باقی رقم (روپے)' : 'Remaining Balance (PKR)', Icons.attach_money),

            const SizedBox(height: 24),

            // Status & Dates
            _buildSectionTitle(isUrdu ? 'حالت اور تاریخ' : 'Status & Timeline'),
            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: selectedStatus,
              items: ['Pending', 'In Progress', 'Ready', 'Delivered']
                  .map((status) {
                return DropdownMenuItem(value: status, child: Text(status));
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedStatus = newValue ?? 'Pending';
                });
              },
              decoration: InputDecoration(
                labelText: isUrdu ? 'آرڈر کی حالت' : 'Order Status',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
            ),

            const SizedBox(height: 12),

            // Due Date Picker
            GestureDetector(
              onTap: _selectDueDate,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.shade50,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isUrdu ? 'ڈیلوری تاریخ: ${dueDate.toString().split(' ')[0]}' : 'Due Date: ${dueDate.toString().split(' ')[0]}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Icon(Icons.calendar_today, color: Colors.blue.shade600),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Notes
            _buildSectionTitle(isUrdu ? 'اضافی نوٹس' : 'Additional Notes'),
            const SizedBox(height: 16),

            _buildTextField(
              notesController,
              isUrdu ? 'آرڈر نوٹس' : 'Order Notes',
              Icons.note,
              isMultiline: true,
            ),

            const SizedBox(height: 32),

            // Action Buttons
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveOrder,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blue.shade600,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  isUrdu ? 'آرڈر محفوظ کریں' : 'Save Order',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.grey.shade400,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  isUrdu ? 'منسوخ' : 'Cancel',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    TextInputType keyboardType = TextInputType.text,
    bool isMultiline = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: isMultiline ? 3 : 1,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blue.shade600),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }

  @override
  void dispose() {
    advanceController.dispose();
    remainingController.dispose();
    notesController.dispose();
    customerSearchController.dispose();
    super.dispose();
  }
}
