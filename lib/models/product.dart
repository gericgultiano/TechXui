class Product {
  final String id;
  final String name;
  final double price;
  final String imageUrl;

  Product(this.id, this.name, this.price, this.imageUrl);

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      json['id'] as String,
      json['name'] as String,
      _parsePrice(json['price']),
      json['imageUrl'] as String,
    );
  }

  static double _parsePrice(dynamic price) {
    if (price is String) {
      return double.tryParse(price) ?? 0.0;
    } else if (price is num) {
      return price.toDouble();
    }
    return 0.0;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Product && id == other.id && imageUrl == other.imageUrl);

  @override
  int get hashCode => id.hashCode ^ imageUrl.hashCode;
}
