/// Offer Model
/// Represents a service offer from companies with pricing and details
class Offer {
  final int? id;
  final String title;
  final String description;
  final double price;
  final String company;
  final String type; // 'urgent' or 'normal'
  final String deliveryTime;
  final String location;
  final int reviewCount;
  final double rating;

  Offer({
    this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.company,
    required this.type,
    this.deliveryTime = '3-5 أيام',
    this.location = 'القاهرة',
    this.reviewCount = 0,
    this.rating = 0.0,
  });

  /// Convert Offer object to Map for database insertion
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'company': company,
      'type': type,
      'deliveryTime': deliveryTime,
      'location': location,
      'reviewCount': reviewCount,
      'rating': rating,
    };
  }

  /// Create Offer object from database Map
  factory Offer.fromMap(Map<String, dynamic> map) {
    return Offer(
      id: map['id'] as int?,
      title: map['title'] as String,
      description: map['description'] as String,
      price: (map['price'] as num).toDouble(),
      company: map['company'] as String,
      type: map['type'] as String,
      deliveryTime: map['deliveryTime'] as String? ?? '3-5 أيام',
      location: map['location'] as String? ?? 'القاهرة',
      reviewCount: map['reviewCount'] as int? ?? 0,
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
    );
  }

  /// Create a copy of Offer with modified fields
  Offer copyWith({
    int? id,
    String? title,
    String? description,
    double? price,
    String? company,
    String? type,
    String? deliveryTime,
    String? location,
    int? reviewCount,
    double? rating,
  }) {
    return Offer(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      company: company ?? this.company,
      type: type ?? this.type,
      deliveryTime: deliveryTime ?? this.deliveryTime,
      location: location ?? this.location,
      reviewCount: reviewCount ?? this.reviewCount,
      rating: rating ?? this.rating,
    );
  }

  /// Check if offer is urgent type
  bool get isUrgent => type.toLowerCase() == 'urgent' || type == 'مستعجل';

  /// Get formatted price with currency
  String get formattedPrice => '${price.toStringAsFixed(0)} ج.م';

  /// Get rating with one decimal place
  String get formattedRating => rating.toStringAsFixed(1);

  @override
  String toString() {
    return 'Offer{id: $id, title: $title, company: $company, price: $price, type: $type, rating: $rating}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Offer && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
