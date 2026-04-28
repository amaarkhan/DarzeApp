class AppStrings {
  // English
  static const Map<String, String> en = {
    // Common
    'app_name': 'DarzeeBook',
    'add': 'Add',
    'edit': 'Edit',
    'delete': 'Delete',
    'save': 'Save',
    'cancel': 'Cancel',
    'search': 'Search',
    'back': 'Back',
    
    // Home
    'home': 'Home',
    'customers': 'Customers',
    'orders': 'Orders',
    'total_customers': 'Total Customers',
    'pending_orders': 'Pending Orders',
    'add_customer': 'Add Customer',
    'add_order': 'Add Order',
    
    // Customer
    'customer_name': 'Customer Name',
    'phone_number': 'Phone Number',
    'photo': 'Photo',
    'cloth_color': 'Cloth Color',
    'customer_id': 'Customer ID',
    'created_date': 'Created Date',
    'no_customers': 'No customers yet',
    
    // Order
    'order_date': 'Order Date',
    'due_date': 'Due Date',
    'status': 'Status',
    'pending': 'Pending',
    'in_progress': 'In Progress',
    'ready': 'Ready',
    'delivered': 'Delivered',
    'advance': 'Advance (PKR)',
    'remaining': 'Remaining (PKR)',
    'notes': 'Notes',
    'cloth_type': 'Cloth Type',
    
    // Cloth Types
    'shalwar_kameez_gents': 'Shalwar Kameez (Gents)',
    'shalwar_kameez_ladies': 'Shalwar Kameez (Ladies)',
    'shirt': 'Shirt',
    'pant': 'Pant/Trouser',
    'sherwani': 'Sherwani',
    'coat_suit': 'Coat/Suit',
    'custom': 'Custom',
    
    // Measurements
    'measurements': 'Measurements',
    'laman': 'Laman (Length)',
    'bazu': 'Bazu (Sleeve)',
    'chaati': 'Chaati (Chest)',
    'kamar': 'Kamar (Waist)',
    'shalwar_length': 'Shalwar Length',
    'paincha': 'Paincha (Bottom)',
    'gol': 'Gol (Hip)',
    'collar_type': 'Collar Type',
    'pocket_style': 'Pocket Style',
    'in_inches': 'in inches',
    
    // Collar types
    'chinese': 'Chinese',
    'v_neck': 'V-Neck',
    'round': 'Round',
    'formal': 'Formal',
    
    // Messages
    'success': 'Success',
    'error': 'Error',
    'customer_added': 'Customer added successfully',
    'order_added': 'Order added successfully',
    'measurement_saved': 'Measurement saved successfully',
  };

  // Urdu
  static const Map<String, String> ur = {
    // Common
    'app_name': 'درزی بک',
    'add': 'شامل کریں',
    'edit': 'ترمیم کریں',
    'delete': 'حذف کریں',
    'save': 'محفوظ کریں',
    'cancel': 'منسوخ کریں',
    'search': 'تلاش کریں',
    'back': 'واپس',
    
    // Home
    'home': 'ہوم',
    'customers': 'کسٹمر',
    'orders': 'آرڈرز',
    'total_customers': 'کل کسٹمرز',
    'pending_orders': 'زیرِ التوا آرڈرز',
    'add_customer': 'کسٹمر شامل کریں',
    'add_order': 'آرڈر شامل کریں',
    
    // Customer
    'customer_name': 'کسٹمر کا نام',
    'phone_number': 'فون نمبر',
    'photo': 'فوٹو',
    'cloth_color': 'کپڑے کا رنگ',
    'customer_id': 'کسٹمر ID',
    'created_date': 'بنایا گیا',
    'no_customers': 'ابھی کوئی کسٹمر نہیں',
    
    // Order
    'order_date': 'آرڈر کی تاریخ',
    'due_date': 'تسلیمی کی تاریخ',
    'status': 'حالت',
    'pending': 'زیر التوا',
    'in_progress': 'جاری ہے',
    'ready': 'تیار',
    'delivered': 'تسلیم شدہ',
    'advance': 'پیشگی رقم',
    'remaining': 'باقی رقم',
    'notes': 'نوٹس',
    'cloth_type': 'کپڑے کی قسم',
    
    // Cloth Types
    'shalwar_kameez_gents': 'شلوار قمیص (مردوں)',
    'shalwar_kameez_ladies': 'شلوار قمیص (خواتین)',
    'shirt': 'کمیض',
    'pant': 'پتلون',
    'sherwani': 'شیروانی',
    'coat_suit': 'کوٹ/سوٹ',
    'custom': 'حسب ضرورت',
    
    // Measurements
    'measurements': 'پیمائشیں',
    'laman': 'لمبائی',
    'bazu': 'بازو',
    'chaati': 'چھاتی',
    'kamar': 'کمر',
    'shalwar_length': 'شلوار کی لمبائی',
    'paincha': 'پاندھے',
    'gol': 'گول',
    'collar_type': 'یقہ کی قسم',
    'pocket_style': 'جیب کا انداز',
    'in_inches': 'انچ میں',
    
    // Collar types
    'chinese': 'چینی',
    'v_neck': 'V نیک',
    'round': 'گول',
    'formal': 'رسمی',
    
    // Messages
    'success': 'کامیاب',
    'error': 'خرابی',
    'customer_added': 'کسٹمر کامیابی سے شامل ہو گیا',
    'order_added': 'آرڈر کامیابی سے شامل ہو گیا',
    'measurement_saved': 'پیمائش کامیابی سے محفوظ ہو گئی',
  };

  static String get(String key, String language) {
    if (language == 'ur') {
      return ur[key] ?? en[key] ?? key;
    }
    return en[key] ?? key;
  }
}
