import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';

@JsonSerializable(createToJson: false)
class Product {
  final int? userId;
  final int? id;
  final String? title;
  final bool? completed;
  int? quantity;

  Product(
      {required this.userId,
      required this.id,
      required this.title,
      required this.completed,
      required this.quantity});

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}
