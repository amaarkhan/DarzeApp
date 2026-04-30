class Order {
  final String id;
  final String customerId;
  final String clothType;
  final DateTime orderDate;
  final DateTime dueDate;
  final String status; // Pending, In Progress, Ready, Delivered
  final double advance;
  final double remaining;
  final String? notes;

  Order({
    required this.id,
    required this.customerId,
    required this.clothType,
    required this.orderDate,
    required this.dueDate,
    required this.status,
    required this.advance,
    required this.remaining,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customerId': customerId,
      'clothType': clothType,
      'orderDate': orderDate.toIso8601String(),
      'dueDate': dueDate.toIso8601String(),
      'status': status,
      'advance': advance,
      'remaining': remaining,
      'notes': notes,
    };
  }

  static Order fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'] as String,
      customerId: map['customerId'] as String,
      clothType: map['clothType'] as String,
      orderDate: DateTime.parse(map['orderDate'] as String),
      dueDate: DateTime.parse(map['dueDate'] as String),
      status: map['status'] as String,
      advance: (map['advance'] as num).toDouble(),
      remaining: (map['remaining'] as num).toDouble(),
      notes: map['notes'] as String?,
    );
  }
}
