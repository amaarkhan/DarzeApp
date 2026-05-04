import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import '../models/customer.dart';
import '../services/customer_pdf_service.dart';
import '../services/db_service.dart';
import '../utils/app_strings.dart';
import 'add_customer_screen.dart';

class CustomerListScreen extends StatefulWidget {
  final String language;

  const CustomerListScreen({Key? key, required this.language}) : super(key: key);

  @override
  State<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  final db = DatabaseService();
  final pdfService = CustomerPdfService();
  final searchController = TextEditingController();
  List<Customer> customers = [];
  List<Customer> filteredCustomers = [];

  @override
  void initState() {
    super.initState();
    _loadCustomers();
    searchController.addListener(_filterCustomers);
  }

  void _loadCustomers() async {
    final data = await db.getAllCustomers();
    setState(() {
      customers = data;
      filteredCustomers = data;
    });
  }

  void _filterCustomers() async {
    if (searchController.text.isEmpty) {
      setState(() {
        filteredCustomers = customers;
      });
    } else {
      final results = await db.searchCustomers(searchController.text);
      setState(() {
        filteredCustomers = results;
      });
    }
  }

  Future<void> _exportCustomersPdf({required bool share}) async {
    if (filteredCustomers.isEmpty) {
      _showSnackBar(widget.language == 'ur'
          ? 'کوئی کسٹمر موجود نہیں'
          : 'No customers to export');
      return;
    }

    try {
      final title = widget.language == 'ur' ? 'کسٹمر لسٹ' : 'Customer List';
      final bytes = await pdfService.buildCustomerListPdf(
        filteredCustomers,
        title: title,
      );
      final fileName =
          'customers_${DateFormat('yyyyMMdd_HHmm').format(DateTime.now())}.pdf';
      final file = await pdfService.savePdf(bytes, fileName);

      if (share) {
        await Share.shareXFiles(
          [XFile(file.path)],
          text: widget.language == 'ur'
              ? 'کسٹمر لسٹ'
              : 'Customer list',
        );
      } else {
        _showSnackBar(
          widget.language == 'ur'
              ? 'پی ڈی ایف فائلز میں محفوظ ہوگئی'
              : 'PDF saved to files: ${file.path}',
        );
      }
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

  void _editCustomer(Customer customer) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddCustomerScreen(
          language: widget.language,
          customer: customer,
        ),
      ),
    ).then((_) => _loadCustomers());
  }

  Future<void> _confirmDeleteCustomer(Customer customer) async {
    final isUrdu = widget.language == 'ur';
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isUrdu ? 'کسٹمر ڈیلیٹ کریں؟' : 'Delete customer?'),
          content: Text(
            isUrdu
                ? 'یہ کسٹمر، اس کے آرڈرز اور پیمائشیں ڈیلیٹ ہو جائیں گی۔'
                : 'This will delete the customer, their orders, and measurements.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(isUrdu ? 'نہیں' : 'Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade600),
              child: Text(isUrdu ? 'ڈیلیٹ' : 'Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      await db.deleteCustomer(customer.id);
      _loadCustomers();
    }
  }

  String _getString(String key) => AppStrings.get(key, widget.language);

  @override
  Widget build(BuildContext context) {
    final isUrdu = widget.language == 'ur';

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.people_alt_rounded, size: 28),
            const SizedBox(width: 12),
            Text(
              isUrdu ? 'کسٹمر' : 'Customers',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'share') {
                _exportCustomersPdf(share: true);
              } else if (value == 'save') {
                _exportCustomersPdf(share: false);
              }
            },
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  value: 'share',
                  child: Text(isUrdu ? 'پی ڈی ایف شیئر کریں' : 'Share PDF'),
                ),
                PopupMenuItem(
                  value: 'save',
                  child: Text(isUrdu ? 'پی ڈی ایف محفوظ کریں' : 'Save PDF'),
                ),
              ];
            },
            icon: const Icon(Icons.picture_as_pdf),
          ),
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade900, Colors.blue.shade700],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Search Field
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: isUrdu ? 'نام، فون نمبر یا آئی ڈی سے تلاش کریں' : 'Search by name, phone, or ID...',
                prefixIcon: const Icon(Icons.search),
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
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),

          // Customer List
          Expanded(
            child: filteredCustomers.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.people_outline, size: 64, color: Colors.grey.shade300),
                        const SizedBox(height: 16),
                        Text(
                          searchController.text.isEmpty
                              ? (isUrdu ? 'ابھی کوئی کسٹمر نہیں' : 'No customers yet')
                              : (isUrdu ? 'کوئی کسٹمر نہیں ملا' : 'No customers found'),
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredCustomers.length,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemBuilder: (context, index) {
                      final customer = filteredCustomers[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: _buildCustomerCard(customer),
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
              builder: (context) => AddCustomerScreen(language: widget.language),
            ),
          ).then((_) => _loadCustomers());
        },
        backgroundColor: Colors.blue.shade600,
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }

  Widget _buildCustomerCard(Customer customer) {
    return Card(
      elevation: 0,
      child: InkWell(
        onTap: () => _editCustomer(customer),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.blue.shade700,
                child: Text(
                  customer.name[0].toUpperCase(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Customer Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customer.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      customer.phone,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'ID: ${customer.id}',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Edit',
                icon: const Icon(Icons.edit),
                color: Colors.blue.shade600,
                onPressed: () => _editCustomer(customer),
              ),
              IconButton(
                tooltip: 'Delete',
                icon: const Icon(Icons.delete_outline),
                color: Colors.red.shade600,
                onPressed: () => _confirmDeleteCustomer(customer),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
