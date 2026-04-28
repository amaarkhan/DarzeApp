import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import '../models/customer.dart';
import '../models/order.dart';
import '../models/measurement.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static SharedPreferences? _preferences;

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal();

  Future<SharedPreferences> get preferences async {
    _preferences ??= await SharedPreferences.getInstance();
    return _preferences!;
  }

  static const String _customersKey = 'customers';
  static const String _ordersKey = 'orders';
  static const String _measurementsKey = 'measurements';

  List<Map<String, dynamic>> _readList(SharedPreferences prefs, String key) {
    final raw = prefs.getString(key);
    if (raw == null || raw.isEmpty) {
      return [];
    }
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded.cast<Map<String, dynamic>>();
  }

  Future<void> _writeList(
    SharedPreferences prefs,
    String key,
    List<Map<String, dynamic>> value,
  ) async {
    await prefs.setString(key, jsonEncode(value));
  }

  // Customer operations
  Future<void> addCustomer(Customer customer) async {
    final prefs = await preferences;
    final customers = _readList(prefs, _customersKey);
    customers.removeWhere((entry) => entry['id'] == customer.id);
    customers.add(customer.toMap());
    await _writeList(prefs, _customersKey, customers);
  }

  Future<List<Customer>> getAllCustomers() async {
    final prefs = await preferences;
    final customers = _readList(prefs, _customersKey);
    return [for (final customer in customers) Customer.fromMap(customer)];
  }

  Future<Customer?> getCustomer(String id) async {
    final customers = await getAllCustomers();
    for (final customer in customers) {
      if (customer.id == id) {
        return customer;
      }
    }
    return null;
  }

  Future<List<Customer>> searchCustomers(String query) async {
    final customers = await getAllCustomers();
    final lowerQuery = query.toLowerCase();
    return customers.where((customer) {
      return customer.name.toLowerCase().contains(lowerQuery) ||
          customer.phone.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  // Order operations
  Future<void> addOrder(Order order) async {
    final prefs = await preferences;
    final orders = _readList(prefs, _ordersKey);
    orders.removeWhere((entry) => entry['id'] == order.id);
    orders.add(order.toMap());
    await _writeList(prefs, _ordersKey, orders);
  }

  Future<List<Order>> getCustomerOrders(String customerId) async {
    final orders = await getAllOrders();
    return orders.where((order) => order.customerId == customerId).toList();
  }

  Future<List<Order>> getAllOrders() async {
    final prefs = await preferences;
    final orders = _readList(prefs, _ordersKey);
    return [for (final order in orders) Order.fromMap(order)];
  }

  Future<void> updateOrder(Order order) async {
    final prefs = await preferences;
    final orders = _readList(prefs, _ordersKey);
    final index = orders.indexWhere((entry) => entry['id'] == order.id);
    if (index >= 0) {
      orders[index] = order.toMap();
      await _writeList(prefs, _ordersKey, orders);
    }
  }

  // Measurement operations
  Future<void> addMeasurement(Measurement measurement) async {
    final prefs = await preferences;
    final measurements = _readList(prefs, _measurementsKey);
    measurements.removeWhere((entry) => entry['id'] == measurement.id);
    measurements.add(measurement.toMap());
    await _writeList(prefs, _measurementsKey, measurements);
  }

  Future<List<Measurement>> getCustomerMeasurements(String customerId) async {
    final prefs = await preferences;
    final measurements = _readList(prefs, _measurementsKey);
    return measurements
        .map(Measurement.fromMap)
        .where((measurement) => measurement.customerId == customerId)
        .toList();
  }

  Future<void> updateMeasurement(Measurement measurement) async {
    final prefs = await preferences;
    final measurements = _readList(prefs, _measurementsKey);
    final index = measurements.indexWhere((entry) => entry['id'] == measurement.id);
    if (index >= 0) {
      measurements[index] = measurement.toMap();
      await _writeList(prefs, _measurementsKey, measurements);
    }
  }
}
