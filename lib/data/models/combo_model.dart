//lib/data/models/combo_model.dart
class ComboModel {
  final int id;
  final String name;
  final String description;
  final double price;
  int quantity;

  ComboModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.quantity = 0,
  });

  factory ComboModel.fromJson(Map<String, dynamic> json) {
    return ComboModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: double.tryParse(json['price'].toString()) ?? 0.0,
    );
  }
}