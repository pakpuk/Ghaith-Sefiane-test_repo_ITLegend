/// Pack Model
/// Represents a product package or bundle with pricing tiers
class Pack {
  final int? id;
  final String name;
  final double price;
  final String description;
  final List<String> features;
  final String duration;
  final bool isPopular;

  Pack({
    this.id,
    required this.name,
    required this.price,
    required this.description,
    this.features = const [],
    this.duration = 'شهري',
    this.isPopular = false,
  });

  /// Convert Pack object to Map for database insertion
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'description': description,
      'features': features.join('|'), // Store as pipe-separated string
      'duration': duration,
      'isPopular': isPopular ? 1 : 0,
    };
  }

  /// Create Pack object from database Map
  factory Pack.fromMap(Map<String, dynamic> map) {
    // Parse features from pipe-separated string
    List<String> featuresList = [];
    final featuresString = map['features'] as String?;
    if (featuresString != null && featuresString.isNotEmpty) {
      featuresList = featuresString.split('|');
    }

    return Pack(
      id: map['id'] as int?,
      name: map['name'] as String,
      price: (map['price'] as num).toDouble(),
      description: map['description'] as String,
      features: featuresList,
      duration: map['duration'] as String? ?? 'شهري',
      isPopular: (map['isPopular'] as int?) == 1,
    );
  }

  /// Create a copy of Pack with modified fields
  Pack copyWith({
    int? id,
    String? name,
    double? price,
    String? description,
    List<String>? features,
    String? duration,
    bool? isPopular,
  }) {
    return Pack(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      description: description ?? this.description,
      features: features ?? this.features,
      duration: duration ?? this.duration,
      isPopular: isPopular ?? this.isPopular,
    );
  }

  /// Get formatted price with currency and duration
  String get formattedPrice => '${price.toStringAsFixed(0)} ج.م / $duration';

  /// Get short formatted price (without duration)
  String get shortPrice => '${price.toStringAsFixed(0)} ج.م';

  /// Get feature count
  int get featureCount => features.length;

  @override
  String toString() {
    return 'Pack{id: $id, name: $name, price: $price, duration: $duration, isPopular: $isPopular, features: ${features.length}}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Pack && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
