import 'dart:convert';

class IncomeRecord {
  const IncomeRecord({
    required this.id,
    required this.amount,
    required this.category,
    required this.note,
    required this.createdAt,
  });

  final String id;
  final double amount;
  final String category;
  final String note;
  final DateTime createdAt;

  IncomeRecord copyWith({
    String? id,
    double? amount,
    String? category,
    String? note,
    DateTime? createdAt,
  }) {
    return IncomeRecord(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'amount': amount,
      'category': category,
      'note': note,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory IncomeRecord.fromJson(Map<String, dynamic> json) {
    return IncomeRecord(
      id: json['id'] as String,
      amount: (json['amount'] as num).toDouble(),
      category: json['category'] as String? ?? '其他',
      note: json['note'] as String? ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  static List<IncomeRecord> decodeList(String source) {
    final data = jsonDecode(source) as List<dynamic>;
    return data
        .map((item) => IncomeRecord.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  static String encodeList(List<IncomeRecord> records) {
    return jsonEncode(records.map((record) => record.toJson()).toList());
  }
}
