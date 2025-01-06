class StoreModel {
  String? id;
  String? name;
  String? description;
  double? price;
  String? imageUrl;
  String? affiliateUrl;  // Amazon product URL
  String? category;
  bool isAvailable;  // Non-nullable with default value
  String? brand;
  double? rating;
  String? primeEligible;
  String? userId;  // admin who added it

  StoreModel({
    this.id,
    this.name,
    this.description,
    this.price,
    this.imageUrl,
    this.affiliateUrl,
    this.category,
    this.isAvailable = true,  // Default value in constructor
    this.brand,
    this.rating,
    this.primeEligible,
    this.userId,
  });

  // Fixed fromJson constructor
  StoreModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        description = json['description'],
        price = json['price']?.toDouble(),
        imageUrl = json['imageUrl'],
        affiliateUrl = json['affiliateUrl'],
        category = json['category'],
        isAvailable = json['isAvailable'] ?? true,  // Initialize with default value
        brand = json['brand'],
        rating = json['rating']?.toDouble(),
        primeEligible = json['primeEligible'],
        userId = json['userId'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['price'] = price;
    data['imageUrl'] = imageUrl;
    data['affiliateUrl'] = affiliateUrl;
    data['category'] = category;
    data['isAvailable'] = isAvailable;
    data['brand'] = brand;
    data['rating'] = rating;
    data['primeEligible'] = primeEligible;
    data['userId'] = userId;
    return data;
  }
}