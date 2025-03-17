class TransactionModel {
  final String id;
  final String productId;
  final String userId;
  final String type;
  final int quantity;
  final String? notes;
  final DateTime createdAt;

  TransactionModel({
    required this.id,
    required this.productId,
    required this.userId,
    required this.type,
    required this.quantity,
    this.notes,
    required this.createdAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      productId: json['product_id'],
      userId: json['user_id'],
      type: json['type'],
      quantity: json['quantity'],
      notes: json['notes'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'user_id': userId,
      'type': type,
      'quantity': quantity,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
