import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/customer.dart';
import '../models/measurement.dart';
import '../services/db_service.dart';
import '../utils/app_strings.dart';

class AddCustomerScreen extends StatefulWidget {
  final String language;
  final Customer? customer;

  const AddCustomerScreen({
    super.key,
    required this.language,
    this.customer,
  });

  @override
  State<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  final db = DatabaseService();
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController colorController;
  late TextEditingController lamanController;
  late TextEditingController bazuController;
  late TextEditingController chaatiController;
  late TextEditingController kamarController;
  late TextEditingController shalwarLengthController;
  late TextEditingController painchaController;
  late TextEditingController golController;
  late TextEditingController notesController;
  
  String selectedClothType = 'Shalwar Kameez (Gents)';
  String selectedCollarType = 'Round';
  String selectedPocketStyle = 'Standard';

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.customer?.name ?? '');
    phoneController = TextEditingController(text: widget.customer?.phone ?? '');
    colorController = TextEditingController();
    lamanController = TextEditingController();
    bazuController = TextEditingController();
    chaatiController = TextEditingController();
    kamarController = TextEditingController();
    shalwarLengthController = TextEditingController();
    painchaController = TextEditingController();
    golController = TextEditingController();
    notesController = TextEditingController();
    
    if (widget.customer != null) {
      _loadMeasurements();
    }
  }

  void _loadMeasurements() async {
    final measurements = await db.getCustomerMeasurements(widget.customer!.id);
    if (measurements.isNotEmpty) {
      final m = measurements.last;
      setState(() {
        selectedClothType = m.clothType;
        colorController.text = m.clothColor ?? '';
        lamanController.text = m.laman?.toString() ?? '';
        bazuController.text = m.bazu?.toString() ?? '';
        chaatiController.text = m.chaati?.toString() ?? '';
        kamarController.text = m.kamar?.toString() ?? '';
        shalwarLengthController.text = m.shalwarLength?.toString() ?? '';
        painchaController.text = m.paincha?.toString() ?? '';
        golController.text = m.gol?.toString() ?? '';
        selectedCollarType = m.collarType ?? 'Round';
        selectedPocketStyle = m.pocketStyle ?? 'Standard';
        notesController.text = m.notes ?? '';
      });
    }
  }

  String _getString(String key) => AppStrings.get(key, widget.language);

  Future<void> _saveCustomer() async {
    if (nameController.text.isEmpty || phoneController.text.isEmpty) {
      _showSnackBar('Please fill all required fields');
      return;
    }

    try {
      final customerId = widget.customer?.id ?? const Uuid().v4();
      
      // Save/Update Customer
      final customer = Customer(
        id: customerId,
        name: nameController.text.trim(),
        phone: phoneController.text.trim(),
        photoPath: null,
        createdAt: widget.customer?.createdAt ?? DateTime.now(),
      );
      
      await db.addCustomer(customer);
      
      // Save Measurement
      final measurement = Measurement(
        id: const Uuid().v4(),
        customerId: customerId,
        clothType: selectedClothType,
        laman: double.tryParse(lamanController.text),
        bazu: double.tryParse(bazuController.text),
        chaati: double.tryParse(chaatiController.text),
        kamar: double.tryParse(kamarController.text),
        shalwarLength: double.tryParse(shalwarLengthController.text),
        paincha: double.tryParse(painchaController.text),
        gol: double.tryParse(golController.text),
        collarType: selectedCollarType,
        pocketStyle: selectedPocketStyle,
        clothColor: colorController.text.trim(),
        notes: notesController.text.trim(),
        createdAt: DateTime.now(),
      );
      
      await db.addMeasurement(measurement);
      
      _showSnackBar('Customer saved successfully!');
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pop(context);
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.customer == null
              ? 'Add New Customer'
              : 'Edit Customer',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Customer Information Section
            _buildSectionTitle('Customer Information'),
            const SizedBox(height: 16),
            _buildTextField(nameController, 'Customer Name', Icons.person),
            const SizedBox(height: 12),
            _buildTextField(phoneController, 'Phone Number', Icons.phone, TextInputType.phone),
            const SizedBox(height: 12),
            _buildTextField(colorController, 'Cloth Color', Icons.palette),
            
            const SizedBox(height: 32),
            
            // Clothing Type Section
            _buildSectionTitle('Clothing Details'),
            const SizedBox(height: 16),
            _buildDropdownField(
              selectedClothType,
              [
                'Shalwar Kameez (Gents)',
                'Shalwar Kameez (Ladies)',
                'Shirt',
                'Pant/Trouser',
                'Sherwani',
                'Coat/Suit',
                'Custom'
              ],
              'Clothing Type',
              (value) {
                setState(() {
                  selectedClothType = value;
                });
              },
            ),
            
            const SizedBox(height: 24),
            
            // Measurements Section
            _buildSectionTitle('Measurements (in inches)'),
            const SizedBox(height: 16),
            _buildMeasurementFields(),
            
            const SizedBox(height: 24),
            
            // Additional Options
            _buildSectionTitle('Additional Options'),
            const SizedBox(height: 16),
            _buildDropdownField(
              selectedCollarType,
              ['Round', 'Chinese', 'V-Neck', 'Formal'],
              'Collar Type',
              (value) {
                setState(() {
                  selectedCollarType = value;
                });
              },
            ),
            const SizedBox(height: 12),
            _buildDropdownField(
              selectedPocketStyle,
              ['Standard', 'Extra', 'None'],
              'Pocket Style',
              (value) {
                setState(() {
                  selectedPocketStyle = value;
                });
              },
            ),
            
            const SizedBox(height: 16),
            _buildTextField(notesController, 'Additional Notes', Icons.note, TextInputType.multiline),
            
            const SizedBox(height: 32),
            
            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveCustomer,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blue.shade600,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Save Customer',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
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
                child: const Text(
                  'Cancel',
                  style: TextStyle(
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
    IconData icon, [
    TextInputType keyboardType = TextInputType.text,
  ]) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: keyboardType == TextInputType.multiline ? 3 : 1,
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

  Widget _buildDropdownField(
    String value,
    List<String> items,
    String label,
    Function(String) onChanged,
  ) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      items: items.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: (newValue) {
        if (newValue != null) onChanged(newValue);
      },
      decoration: InputDecoration(
        labelText: label,
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

  Widget _buildMeasurementFields() {
    List<String> fields = [];
    
    if (selectedClothType == 'Shalwar Kameez (Gents)' || 
        selectedClothType == 'Shalwar Kameez (Ladies)') {
      fields = ['Laman', 'Bazu', 'Chaati', 'Kamar', 'Shalwar Length', 'Paincha', 'Gol'];
    } else if (selectedClothType == 'Shirt') {
      fields = ['Laman', 'Bazu', 'Chaati', 'Kamar'];
    } else if (selectedClothType == 'Pant/Trouser') {
      fields = ['Laman', 'Kamar', 'Paincha'];
    } else if (selectedClothType == 'Sherwani') {
      fields = ['Laman', 'Bazu', 'Chaati', 'Kamar'];
    } else if (selectedClothType == 'Coat/Suit') {
      fields = ['Laman', 'Bazu', 'Chaati', 'Kamar'];
    }

    return Column(
      children: [
        if (fields.contains('Laman'))
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: _buildTextField(lamanController, 'Laman (Length)', Icons.straighten),
          ),
        if (fields.contains('Bazu'))
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: _buildTextField(bazuController, 'Bazu (Sleeve)', Icons.straighten),
          ),
        if (fields.contains('Chaati'))
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: _buildTextField(chaatiController, 'Chaati (Chest)', Icons.straighten),
          ),
        if (fields.contains('Kamar'))
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: _buildTextField(kamarController, 'Kamar (Waist)', Icons.straighten),
          ),
        if (fields.contains('Shalwar Length'))
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: _buildTextField(shalwarLengthController, 'Shalwar Length', Icons.straighten),
          ),
        if (fields.contains('Paincha'))
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: _buildTextField(painchaController, 'Paincha (Bottom Width)', Icons.straighten),
          ),
        if (fields.contains('Gol'))
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: _buildTextField(golController, 'Gol (Hip)', Icons.straighten),
          ),
      ],
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    colorController.dispose();
    lamanController.dispose();
    bazuController.dispose();
    chaatiController.dispose();
    kamarController.dispose();
    shalwarLengthController.dispose();
    painchaController.dispose();
    golController.dispose();
    notesController.dispose();
    super.dispose();
  }
}
