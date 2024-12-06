class Product {
  final int id;
  final String title;
  final String description;
  final int mrpPrice;
  final int sellingPrice;
  final int discountPrice;
  final int quantity;
  final String color;
  final List<String> images;
  final String sizes;
  final Seller seller;
  final String createdAt;
  final Category category;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.mrpPrice,
    required this.sellingPrice,
    required this.discountPrice,
    required this.quantity,
    required this.color,
    required this.images,
    required this.sizes,
    required this.seller,
    required this.createdAt,
    required this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    var imagesFromJson = json['images'] as List;
    List<String> imagesList = imagesFromJson.map((i) => i as String).toList();

    return Product(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      mrpPrice: json['mrpPrice'],
      sellingPrice: json['sellingPrice'],
      discountPrice: json['discountPrice'],
      quantity: json['quantity'],
      color: json['color'],
      images: imagesList,
      sizes: json['sizes'],
      seller: Seller.fromJson(json['seller']),
      createdAt: json['createdAt'],
      category: Category.fromJson(json['category']),
    );
  }
}

class Seller {
  final String sellerName;
  final String mobile;
  final String email;

  Seller({
    required this.sellerName,
    required this.mobile,
    required this.email,
  });

  factory Seller.fromJson(Map<String, dynamic> json) {
    return Seller(
      sellerName: json['sellerName'],
      mobile: json['mobile'],
      email: json['email'],
    );
  }
}

class Category {
  final String categoryId;

  Category({required this.categoryId});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      categoryId: json['categoryId'],
    );
  }
}
