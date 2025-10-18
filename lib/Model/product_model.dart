class Product {
  final int? id;
  final String name;
  final String? description;
  final double price;
  final String image;
  final int categoryId;
  final String subcategory;
  final String offerType;
  final String location;
  bool isFavorite;

  Product({
    this.id,
    required this.name,
    this.description,
    required this.price,
    required this.image,
    required this.categoryId,
    required this.subcategory,
    required this.offerType,
    this.location = 'القاهرة',
    this.isFavorite = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'image': image,
      'categoryId': categoryId,
      'subcategory': subcategory,
      'offerType': offerType,
      'location': location,
      'isFavorite': isFavorite ? 1 : 0,
    };
  }

  /// Create Product object from database Map
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as int?,
      name: map['name'] as String,
      description: map['description'] as String?,
      price: (map['price'] as num).toDouble(),
      image: map['image'] as String,
      categoryId: map['categoryId'] as int,
      subcategory: map['subcategory'] as String,
      offerType: map['offerType'] as String,
      location: map['location'] as String? ?? 'القاهرة',
      isFavorite: (map['isFavorite'] as int?) == 1,
    );
  }

  /// Create a copy of Product with modified fields
  Product copyWith({
    int? id,
    String? name,
    String? description,
    double? price,
    String? image,
    int? categoryId,
    String? subcategory,
    String? offerType,
    String? location,
    bool? isFavorite,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      image: image ?? this.image,
      categoryId: categoryId ?? this.categoryId,
      subcategory: subcategory ?? this.subcategory,
      offerType: offerType ?? this.offerType,
      location: location ?? this.location,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  bool get isUrgent =>
      offerType.toLowerCase() == 'urgent' || offerType == 'مستعجل';

  /// Get formatted price with currency
  String get formattedPrice => '${price.toStringAsFixed(0)} ج.م';

  @override
  String toString() {
    return 'Product{id: $id, name: $name, price: $price, subcategory: $subcategory, offerType: $offerType}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Product && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
