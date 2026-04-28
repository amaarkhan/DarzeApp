class Measurement {
  final String id;
  final String customerId;
  final String clothType;
  final double? laman;
  final double? bazu;
  final double? chaati;
  final double? kamar;
  final double? shalwarLength;
  final double? paincha;
  final double? gol;
  final String? collarType;
  final String? pocketStyle;
  final String? clothColor;
  final String? notes;
  final DateTime createdAt;

  Measurement({
    required this.id,
    required this.customerId,
    required this.clothType,
    this.laman,
    this.bazu,
    this.chaati,
    this.kamar,
    this.shalwarLength,
    this.paincha,
    this.gol,
    this.collarType,
    this.pocketStyle,
    this.clothColor,
    this.notes,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customerId': customerId,
      'clothType': clothType,
      'laman': laman,
      'bazu': bazu,
      'chaati': chaati,
      'kamar': kamar,
      'shalwarLength': shalwarLength,
      'paincha': paincha,
      'gol': gol,
      'collarType': collarType,
      'pocketStyle': pocketStyle,
      'clothColor': clothColor,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  static Measurement fromMap(Map<String, dynamic> map) {
    return Measurement(
      id: map['id'] as String,
      customerId: map['customerId'] as String,
      clothType: map['clothType'] as String,
      laman: (map['laman'] as num?)?.toDouble(),
      bazu: (map['bazu'] as num?)?.toDouble(),
      chaati: (map['chaati'] as num?)?.toDouble(),
      kamar: (map['kamar'] as num?)?.toDouble(),
      shalwarLength: (map['shalwarLength'] as num?)?.toDouble(),
      paincha: (map['paincha'] as num?)?.toDouble(),
      gol: (map['gol'] as num?)?.toDouble(),
      collarType: map['collarType'] as String?,
      pocketStyle: map['pocketStyle'] as String?,
      clothColor: map['clothColor'] as String?,
      notes: map['notes'] as String?,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }
}
