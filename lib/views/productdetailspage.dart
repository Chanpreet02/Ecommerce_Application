/*
import 'package:final_commerce/views/cart_manager.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/product.dart';

class ProductDetailsPage extends StatefulWidget {
  final int productId;

  ProductDetailsPage({required this.productId});

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  late Product product;
  bool isLoading = true;
  int quantity = 1;

  @override
  void initState() {
    super.initState();
    fetchProductDetails();
  }

  Future<void> fetchProductDetails() async {
    try {
      final response = await http.get(Uri.parse("http://localhost:5555/products/${widget.productId}"));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          product = Product.fromJson(data['content'][0]); // Assuming the response contains a list of products under 'content'
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load product');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Handle network or data parsing errors here
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load product. Please try again later.')));
    }
  }

  void _addToCart() {
    CartManager.addToCart( productId: 0, size: '', quantity: 0, token: '');
    // Show a confirmation message
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Added to cart')));
  }

  void _increaseQuantity() {
    setState(() {
      quantity++;
    });
  }

  void _decreaseQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: isLoading ? Text("Loading...") : Text(product.title),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, "/cart");
              },
              child: Icon(Icons.shopping_cart),
            ),
          ],
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Images
                Image.network(product.images[0]), // Show first image
                SizedBox(height: 10),
                // Product Title
                Text(
                  product.title,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                // Product Price
                Text(
                  "\$${product.sellingPrice}",
                  style: TextStyle(fontSize: 18, color: Colors.green),
                ),
                SizedBox(height: 10),
                // Product Description
                Text(
                  product.description,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                // Product Seller Info
                Text("Seller: ${product.seller.sellerName}"),
                Text("Seller Contact: ${product.seller.mobile}"),
                SizedBox(height: 10),
                // Quantity Controls
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: _decreaseQuantity,
                    ),
                    Text('$quantity'),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: _increaseQuantity,
                    ),
                  ],
                ),
                // Add to Cart Button
                TextButton(
                  onPressed: _addToCart,
                  child: Text(
                    "Add to Cart",
                    style: TextStyle(fontSize: 18),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    textStyle: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
*/
/*
import 'dart:convert'; // For JSON decoding
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // For HTTP requests

// Product model class (assuming this exists in your models folder)
class Product {
  final int id;
  final String title;
  final double sellingPrice;
  final String description;
  final List<String> images;
  final Seller seller;

  Product({
    required this.id,
    required this.title,
    required this.sellingPrice,
    required this.description,
    required this.images,
    required this.seller,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      sellingPrice: json['sellingPrice'].toDouble(),
      description: json['description'],
      images: List<String>.from(json['images']),
      seller: Seller.fromJson(json['seller']),
    );
  }
}

class Seller {
  final String sellerName;
  final String mobile;

  Seller({required this.sellerName, required this.mobile});

  factory Seller.fromJson(Map<String, dynamic> json) {
    return Seller(
      sellerName: json['sellerName'],
      mobile: json['mobile'],
    );
  }
}

class ProductDetailsPage extends StatefulWidget {
  final int productId;

  ProductDetailsPage({required this.productId});

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  late Product product;
  bool isLoading = true;
  int quantity = 1;

  @override
  void initState() {
    super.initState();
    fetchProductDetails();
  }

  // Fetch product details from API
  Future<void> fetchProductDetails() async {
    final response = await http.get(Uri.parse("http://localhost:5555/products/${widget.productId}"));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        product = Product.fromJson(data['content'][0]); // Assuming the response contains a 'content' array
        isLoading = false;
      });
    } else {
      // Handle error
      throw Exception('Failed to load product');
    }
  }

  // Add product to cart logic
  void _addToCart() {
    CartManager.addToCart(product);
  }

  void _increaseQuantity() {
    setState(() {
      quantity++;
    });
  }

  void _decreaseQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: isLoading ? Text("Loading...") : Text(product.title),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, "/cart");
              },
              child: Icon(Icons.shopping_cart),
            ),
          ],
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Images
                Image.network(product.images[0]), // Show the first image
                SizedBox(height: 10),
                // Product Title
                Text(
                  product.title,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                // Product Price
                Text(
                  "\$${product.sellingPrice.toStringAsFixed(2)}",
                  style: TextStyle(fontSize: 18, color: Colors.green),
                ),
                SizedBox(height: 10),
                // Product Description
                Text(
                  product.description,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                // Product Seller Info
                Text("Seller: ${product.seller.sellerName}"),
                Text("Seller Contact: ${product.seller.mobile}"),
                SizedBox(height: 10),
                // Quantity Controls
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: _decreaseQuantity,
                    ),
                    Text('$quantity'),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: _increaseQuantity,
                    ),
                  ],
                ),
                // Add to Cart Button
                TextButton(
                  onPressed: _addToCart,
                  child: Text(
                    "Add to Cart",
                    style: TextStyle(fontSize: 18),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    textStyle: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  double get totalPrice => product.sellingPrice * quantity;
}

class CartManager {
  static List<CartItem> cartItems = [];

  static void addToCart(Product product) {
    // Check if product already exists in the cart
    CartItem? existingItem = cartItems.firstWhere(
          (item) => item.product.id == product.id,
      orElse: () => CartItem(product: product),
    );

    // If product already exists, update quantity, else add a new item
    if (existingItem != null && cartItems.contains(existingItem)) {
      existingItem.quantity++;
    } else {
      cartItems.add(CartItem(product: product));
    }
  }

  static void removeFromCart(Product product) {
    cartItems.removeWhere((item) => item.product.id == product.id);
  }

  static void updateQuantity(Product product, int newQuantity) {
    // Find the CartItem for the given product
    CartItem item = cartItems.firstWhere((item) => item.product.id == product.id);

    // Update the quantity of the CartItem
    item.quantity = newQuantity;
  }

  static double getTotal() {
    return cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
  }
}
*/




import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Product Model (Reused from homepage)
class Product {
  final int id;
  final String title;
  final String description;
  final double mrpPrice;
  final double sellingPrice;
  final double discountPrice;
  final String color;
  final List<String> images;
  final String sizes;
  final String sellerName;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.mrpPrice,
    required this.sellingPrice,
    required this.discountPrice,
    required this.color,
    required this.images,
    required this.sizes,
    required this.sellerName,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      mrpPrice: json['mrpPrice'].toDouble(),
      sellingPrice: json['sellingPrice'].toDouble(),
      discountPrice: json['discountPrice'].toDouble(),
      color: json['color'],
      images: List<String>.from(json['images']),
      sizes: json['sizes'],
      sellerName: json['seller']['sellerName'], // Access seller's name from nested object
    );
  }
}

class ProductDetailsPage extends StatefulWidget {
  final int productId;

  ProductDetailsPage({required this.productId});

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  late Product product;
  bool isLoading = true;  // Add a loading flag to show the CircularProgressIndicator
  int quantity = 1;

  // Fetch Product details by ID
  Future<void> fetchProductDetails() async {
    final response = await http.get(
      Uri.parse("http://localhost:5555/products/${widget.productId}"), // Update API endpoint accordingly
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        product = Product.fromJson(data);
        isLoading = false;  // Set loading flag to false after data is loaded
      });
    } else {
      setState(() {
        isLoading = false;  // Set loading flag to false if API call fails
      });
      throw Exception('Failed to load product details');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProductDetails();
  }
  void _addToCart() {
    // Add the product to cart logic
  }

  void _increaseQuantity() {
    setState(() {
      quantity++;
    });
    // Update cart quantity logic
  }

  void _decreaseQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
      // Update cart quantity logic
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(isLoading ? 'Loading...' : product.title),  // Show 'Loading...' while the product is being fetched
      ),
      body: isLoading  // Show the CircularProgressIndicator while loading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                product.images.isNotEmpty ? product.images[0] : '',
                width: double.infinity,
                height: 300,
              ),
              SizedBox(height: 16),
              Text(
                product.title,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                "\$${product.sellingPrice.toStringAsFixed(2)}",
                style: TextStyle(color: Colors.green, fontSize: 18),
              ),
              SizedBox(height: 16),
              Text(
                product.description,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                "Sizes Available: ${product.sizes}",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                "Color: ${product.color}",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, "/sellerform"); // Navigate to seller form
                },
                child: Text(
                  "Seller: ${product.sellerName}",
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Add to Cart and Wishlist options here
              TextButton(
                onPressed: _addToCart,
                child: Text(
                  "Add to Cart",
                  style: TextStyle(fontSize: 18),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  textStyle: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  double get totalPrice => product.sellingPrice * quantity;
}

class CartManager {
  static List<CartItem> cartItems = [];

  static void addToCart(Product product) {
    // Check if product already exists in the cart
    CartItem? existingItem = cartItems.firstWhere(
    (item) => item.product.id == product.id,
      orElse: () => CartItem(product: product), // Return a new CartItem if not found
    );

    // If product already exists, update quantity, else add a new item
    if (existingItem != null && cartItems.contains(existingItem)) {
      existingItem.quantity++;
    } else {
      cartItems.add(CartItem(product: product));
    }
  }


  static void removeFromCart(Product product) {
    cartItems.removeWhere((item) => item.product.id == product.id);
  }

  static void updateQuantity(Product product, int newQuantity) {
    // Find the CartItem for the given product
    CartItem item = cartItems.firstWhere((item) => item.product.id == product.id);

    // Update the quantity of the CartItem
    item.quantity = newQuantity;
  }



  static double getTotal() {
    return cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
  }
}

