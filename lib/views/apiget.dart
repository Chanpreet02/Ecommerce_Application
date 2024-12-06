/*
import 'package:final_commerce/views/productdetailspage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
      sellerName: json['sellerName'],
    );
  }
}

class ApiGet extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => apiState();
}

class apiState extends State<ApiGet> {
  late List<Product> products = [];

  // API call to fetch products
  Future apicall() async {
    http.Response responses;
    responses = await http.get(Uri.parse("http://localhost:5555/products")); // Update the API URL accordingly

    if (responses.statusCode == 200) {
      final data = json.decode(responses.body); // This will be a list of products (List<dynamic>)

      setState(() {
        // Convert the list of dynamic objects into List<Product>
        products = List<Product>.from(data.map((item) => Product.fromJson(item)));
      });
    } else {
      // Handle error
      throw Exception('Failed to load products');
    }
  }

  @override
  void initState() {
    apicall();
    super.initState();
  }

  // Function to group products in sets of 10 and add headings
  List<Widget> _buildRows(List<Product> products) {
    List<Widget> rows = [];
    String? currentCategory = ''; // Variable to track the current category

    for (int i = 0; i < products.length; i += 10) {
      // Slice the list to get 10 items per row
      List<Product> rowItems = products.sublist(i, i + 10 > products.length ? products.length : i + 10);

      // Add the row with items
      rows.add(SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: rowItems.map((product) {
            return GestureDetector(
              onTap: () {
                // Navigate to ProductDetailsPage when the product card is tapped
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailsPage(productId: product.id),
                  ),
                );
              },
              child: Container(
                width: 200, // Increased width to 200 for a larger size
                margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Increased margin
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          product.images.isNotEmpty ? product.images[0] : '', // Use the first image
                          width: 200, // Adjusted image width to match container size
                          height: 200, // Adjusted image height
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0), // Increased padding for better spacing
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.title.toString(),
                              style: TextStyle(fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 6),
                            Text(
                              product.description,
                              style: TextStyle(fontSize: 12),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 6), // Slightly bigger space
                            Text(
                              "\$${product.sellingPrice.toStringAsFixed(2)}",
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            // GestureDetector for Seller Details
                            GestureDetector(
                              onTap: () {
                                // Navigate to "/sellerdetails" when seller name is tapped
                                Navigator.pushNamed(context, "/sellerform");
                              },
                              child: Text(
                                "Seller: ${product.sellerName}",
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ));
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(120), // Increase the height for more space
          child: AppBar(
            backgroundColor: Colors.blueAccent, // AppBar color
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context); // Go back to the previous screen
              },
            ),
            flexibleSpace: SingleChildScrollView( // Add a scroll view to prevent overflow
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Navigate when KartFlip + Explore Plus are tapped
                        Navigator.pushNamed(context, "/");
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 40.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "KartFlip", // Logo text
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Explore Plus", // Explore Plus text
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Container(
                            height: 40, // Adjusted height to match new size
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: TextField(
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.search),
                                hintText: 'Search for products, brands...',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            // Navigate to Profile page
                            Navigator.pushNamed(context, "/datapage");
                          },
                          child: Icon(
                            Icons.account_circle,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            // Navigate to some other random page
                            Navigator.pushNamed(context, "/cart");
                          },
                          child: Icon(
                            Icons.shopping_cart,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: products.isEmpty
            ? Center(child: CircularProgressIndicator()) // Show loading spinner while data is being fetched
            : SingleChildScrollView(
          child: Column(
            children: _buildRows(products), // Build rows dynamically
          ),
        ),
      ),
    );
  }
}
*/

//Attempt 2
/*
import 'package:final_commerce/views/productdetailspage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'cart_manager.dart';

// Define the Product model class
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

class ApiGet extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => apiState();
}

class apiState extends State<ApiGet> {
  late List<Product> products = [];

  // API call to fetch products
  Future apicall() async {
    http.Response responses;
    responses = await http.get(Uri.parse("http://localhost:5555/products")); // Update the API URL accordingly

    if (responses.statusCode == 200) {
      final data = json.decode(responses.body); // Decode the JSON response
      final List<dynamic> content = data['content']; // Extract 'content' array

      setState(() {
        // Convert the list of dynamic objects into List<Product>
        products = List<Product>.from(content.map((item) => Product.fromJson(item)));
      });
    } else {
      // Handle error
      throw Exception('Failed to load products');
    }
  }

  @override
  void initState() {
    apicall();
    super.initState();
  }

  // Function to group products in sets of 10 and add headings
  List<Widget> _buildRows(List<Product> products) {
    List<Widget> rows = [];

    for (int i = 0; i < products.length; i += 10) {
      // Slice the list to get 10 items per row
      List<Product> rowItems = products.sublist(i, i + 10 > products.length ? products.length : i + 10);

      // Add the row with items
      rows.add(SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: rowItems.map((product) {
            return GestureDetector(
              onTap: () {
                // Navigate to ProductDetailsPage when the product card is tapped
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailsPage(productId: product.id),
                  ),
                );
              },
              child: Container(
                width: 200, // Increased width to 200 for a larger size
                margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Increased margin
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          product.images.isNotEmpty ? product.images[0] : '', // Use the first image
                          width: 200, // Adjusted image width to match container size
                          height: 200, // Adjusted image height
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0), // Increased padding for better spacing
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.title,
                              style: TextStyle(fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 6),
                            Text(
                              product.description,
                              style: TextStyle(fontSize: 12),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 6), // Slightly bigger space
                            Text(
                              "\$${product.sellingPrice.toStringAsFixed(2)}",
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            // GestureDetector for Seller Details
                            GestureDetector(
                              onTap: () {
                                // Navigate to "/sellerdetails" when seller name is tapped
                                Navigator.pushNamed(context, "/sellerform");
                              },
                              child: Text(
                                "Seller: ${product.sellerName}",
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                            // Cart icon to add product to cart
                            GestureDetector(
                              onTap: () {
                                CartManager.addToCart(
                                  productId: product.id, // Correctly accessing product's ID
                                  size: 'M', // Example size
                                  quantity: 1, // Default quantity
                                  token: "eyJhbGciOiJIUzM4NCJ9.eyJpYXQiOjE3MzI3NTA1MjQsImV4cCI6MTczMjgzNjkyNCwiZW1haWwiOiJzYW55YWdlcmEucHJhYmhAZ21haWwuY29tIiwiYXV0aG9yaXRpZXMiOiJST0xFX0NVU1RPTUVSIn0.4dQO9hZnaASZb0OzV1y3iFXzhCkzTRkHLz9mYXqthdHMZ0zrwF3tf101AKS9OY0d", // JWT token
                                );
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Added to cart')));
                              },
                              child: Icon(
                                Icons.shopping_cart,
                                size: 30,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ));
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(120), // Increase the height for more space
          child: AppBar(
            backgroundColor: Colors.blueAccent, // AppBar color
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context); // Go back to the previous screen
              },
            ),
            flexibleSpace: SingleChildScrollView( // Add a scroll view to prevent overflow
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Navigate when KartFlip + Explore Plus are tapped
                        Navigator.pushNamed(context, "/");
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 40.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "KartFlip", // Logo text
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Explore Plus", // Explore Plus text
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Container(
                            height: 40, // Adjusted height to match new size
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: TextField(
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.search),
                                hintText: 'Search for products, brands...',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            // Navigate to Profile page
                            Navigator.pushNamed(context, "/datapage");
                          },
                          child: Icon(
                            Icons.account_circle,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        SizedBox(width: 10),
                        // Cart icon added to navigate to the cart details page
                        GestureDetector(
                          onTap: () {
                            // Navigate to the Cart page
                            Navigator.pushNamed(context, "/cart"); // Replace with your cart page route
                          },
                          child: Icon(
                            Icons.shopping_cart,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: products.isEmpty
            ? Center(child: CircularProgressIndicator()) // Show loading spinner while data is being fetched
            : SingleChildScrollView(
          child: Column(
            children: _buildRows(products), // Build rows dynamically
          ),
        ),
      ),
    );
  }
}
*/
/*
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'cart_manager.dart';
import 'wishlist.dart'; // Import the wishlist file
import 'productdetailspage.dart';

// Define the Product model class
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

class ApiGet extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => apiState();
}

class apiState extends State<ApiGet> {
  late List<Product> products = [];

  // API call to fetch products
  Future apicall() async {
    http.Response responses;
    responses = await http.get(Uri.parse("http://localhost:5555/products")); // Update the API URL accordingly

    if (responses.statusCode == 200) {
      final data = json.decode(responses.body); // Decode the JSON response
      final List<dynamic> content = data['content']; // Extract 'content' array

      setState(() {
        // Convert the list of dynamic objects into List<Product>
        products = List<Product>.from(content.map((item) => Product.fromJson(item)));
      });
    } else {
      // Handle error
      throw Exception('Failed to load products');
    }
  }

  @override
  void initState() {
    apicall();
    super.initState();
  }

  // Function to group products in sets of 10 and add headings
  List<Widget> _buildRows(List<Product> products) {
    List<Widget> rows = [];

    for (int i = 0; i < products.length; i += 10) {
      // Slice the list to get 10 items per row
      List<Product> rowItems = products.sublist(i, i + 10 > products.length ? products.length : i + 10);

      // Add the row with items
      rows.add(SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: rowItems.map((product) {
            return GestureDetector(
              onTap: () {
                // Navigate to ProductDetailsPage when the product card is tapped
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailsPage(productId: product.id),
                  ),
                );
              },
              child: Container(
                width: 200, // Increased width to 200 for a larger size
                margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Increased margin
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          product.images.isNotEmpty ? product.images[0] : '', // Use the first image
                          width: 200, // Adjusted image width to match container size
                          height: 200, // Adjusted image height
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0), // Increased padding for better spacing
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.title,
                              style: TextStyle(fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 6),
                            Text(
                              product.description,
                              style: TextStyle(fontSize: 12),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 6), // Slightly bigger space
                            Text(
                              "\$${product.sellingPrice.toStringAsFixed(2)}",
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            // GestureDetector for Seller Details
                            GestureDetector(
                              onTap: () {
                                // Navigate to "/sellerdetails" when seller name is tapped
                                Navigator.pushNamed(context, "/sellerform");
                              },
                              child: Text(
                                "Seller: ${product.sellerName}",
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                            // Cart icon to add product to cart
                            GestureDetector(
                              onTap: () {
                                CartManager.addToCart(
                                  productId: product.id, // Correctly accessing product's ID
                                  size: 'M', // Example size
                                  quantity: 1, // Default quantity
                                  token: "eyJhbGciOiJIUzM4NCJ9.eyJpYXQiOjE3MzI3NTA1MjQsImV4cCI6MTczMjgzNjkyNCwiZW1haWwiOiJzYW55YWdlcmEucHJhYmhAZ21haWwuY29tIiwiYXV0aG9yaXRpZXMiOiJST0xFX0NVU1RPTUVSIn0.4dQO9hZnaASZb0OzV1y3iFXzhCkzTRkHLz9mYXqthdHMZ0zrwF3tf101AKS9OY0d", // JWT token
                                );
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Added to cart')));
                              },
                              child: Icon(
                                Icons.shopping_cart,
                                size: 30,
                              ),
                            ),
                            // Wishlist icon to add product to wishlist
                            GestureDetector(
                              onTap: () {
                                // Add product to wishlist and refresh the wishlist screen
                                _addToWishlist(product.id);
                              },
                              child: Icon(
                                Icons.favorite_border,
                                size: 30,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ));
    }
    return rows;
  }

  // Call the wishlist API to add product
  void _addToWishlist(int productId) {
    final String token = "eyJhbGciOiJIUzM4NCJ9.eyJpYXQiOjE3MzI3NTcwMDQsImV4cCI6MTczMjg0MzQwNCwiZW1haWwiOiJndXJwcmVldGthdXI4ODMzOUBnbWFpbC5jb20iLCJhdXRob3JpdGllcyI6IlJPTEVfQ1VTVE9NRVIifQ.MyDB2DRecxDg3qg3kL9-kLGfYl_ATVHigLgs-NteDspjXjGmu5LpS5IzqXpEMkkg"; // Replace with actual JWT token
    final url = "http://localhost:5555/api/wishlist/add-product/$productId";

    http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    ).then((response) {
      if (response.statusCode == 200) {
        // Successfully added to wishlist
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Added to Wishlist!'),
        ));
        // After adding to wishlist, navigate to the WishlistPage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => WishlistPage(token: token)),
        );
      } else {
        // Failed to add to wishlist
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to add to Wishlist'),
        ));
      }
    }).catchError((error) {
      // Handle any error (e.g., network error)
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: $error'),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(120),
          child: AppBar(
            backgroundColor: Colors.blueAccent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            flexibleSpace: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, "/");
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 40.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "KartFlip",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Explore Plus",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: TextField(
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.search),
                                hintText: 'Search for products, brands...',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, "/datapage");
                          },
                          child: Icon(
                            Icons.account_circle,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, "/cart");
                          },
                          child: Icon(
                            Icons.shopping_cart,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, "/wishlist");
                          },
                          child: Icon(
                            Icons.favorite_border,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: products.isEmpty
            ? Center(child: CircularProgressIndicator()) // Show loading spinner while data is being fetched
            : SingleChildScrollView(
          child: Column(
            children: _buildRows(products),
          ),
        ),
      ),
    );
  }
}
*/
/*
import 'package:final_commerce/views/productdetailspage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'cart_manager.dart';
import 'package:final_commerce/views/wishlist.dart';

// Define the Product model class
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

class ApiGet extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => apiState();
}

class apiState extends State<ApiGet> {
  late List<Product> products = [];
  late List<Product> wishlist = []; // Local list for wishlist

  // API call to fetch products
  Future apicall() async {
    http.Response responses;
    responses = await http.get(Uri.parse("http://localhost:5555/products")); // Update the API URL accordingly

    if (responses.statusCode == 200) {
      final data = json.decode(responses.body); // Decode the JSON response
      final List<dynamic> content = data['content']; // Extract 'content' array

      setState(() {
        // Convert the list of dynamic objects into List<Product>
        products = List<Product>.from(content.map((item) => Product.fromJson(item)));
      });
    } else {
      // Handle error
      throw Exception('Failed to load products');
    }
  }

  @override
  void initState() {
    apicall();
    super.initState();
  }

  // Function to group products in sets of 10 and add headings
  List<Widget> _buildRows(List<Product> products) {
    List<Widget> rows = [];

    for (int i = 0; i < products.length; i += 10) {
      // Slice the list to get 10 items per row
      List<Product> rowItems = products.sublist(i, i + 10 > products.length ? products.length : i + 10);

      // Add the row with items
      rows.add(SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: rowItems.map((product) {
            return GestureDetector(
              onTap: () {
                // Navigate to ProductDetailsPage when the product card is tapped
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailsPage(productId: product.id),
                  ),
                );
              },
              child: Container(
                width: 200, // Increased width to 200 for a larger size
                margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Increased margin
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          product.images.isNotEmpty ? product.images[0] : '', // Use the first image
                          width: 200, // Adjusted image width to match container size
                          height: 200, // Adjusted image height
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0), // Increased padding for better spacing
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.title,
                              style: TextStyle(fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 6),
                            Text(
                              product.description,
                              style: TextStyle(fontSize: 12),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 6), // Slightly bigger space
                            Text(
                              "\$${product.sellingPrice.toStringAsFixed(2)}",
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            // GestureDetector for Seller Details
                            GestureDetector(
                              onTap: () {
                                // Navigate to "/sellerdetails" when seller name is tapped
                                Navigator.pushNamed(context, "/sellerform");
                              },
                              child: Text(
                                "Seller: ${product.sellerName}",
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                            // Cart icon to add product to cart
                            GestureDetector(
                              // onTap: () {
                              //   CartManager.addToCart(
                              //     productId: product.id, // Correctly accessing product's ID
                              //     size: 'M', // Example size
                              //     quantity: 1, // Default quantity
                              //     token: "eyJhbGciOiJIUzM4NCJ9.eyJpYXQiOjE3MzI3NTA1MjQsImV4cCI6MTczMjgzNjkyNCwiZW1haWwiOiJzYW55YWdlcmEucHJhYmhAZ21haWwuY29tIiwiYXV0aG9yaXRpZXMiOiJST0xFX0NVU1RPTUVSIn0.4dQO9hZnaASZb0OzV1y3iFXzhCkzTRkHLz9mYXqthdHMZ0zrwF3tf101AKS9OY0d", // Replace with actual JWT token
                              //   );
                              //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Added to cart')));
                              // },
                              child: Icon(
                                Icons.shopping_cart,
                                size: 30,
                              ),
                            ),
                            // Wishlist icon to add product to wishlist
                            GestureDetector(
                              onTap: () {
                                // Add product to local wishlist list
                                setState(() {
                                  wishlist.add(product); // Add to local wishlist
                                });
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Added to Wishlist')));
                              },
                              child: Icon(
                                Icons.favorite_border,
                                size: 30,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ));
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(120),
          child: AppBar(
            backgroundColor: Colors.blueAccent,
            elevation: 0,
            flexibleSpace: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "KartFlip", // Logo text
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search),
                              hintText: 'Search for products, brands...',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        body: products.isEmpty
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(child: Column(children: _buildRows(products))),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.home),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/home');
                },
              ),
              // IconButton(
              //   icon: Icon(Icons.favorite),
              //   // onPressed: () {
              //   //   // Navigate to the WishlistPage
              //   //   Navigator.push(
              //   //     context,
              //   //     MaterialPageRoute(
              //   //       builder: (context) => WishlistPage(wishlist: wishlist),
              //   //     ),
              //   //   );
              //   // },
              // ),
              IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.pushNamed(context, "/cart");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/
/*
import 'package:final_commerce/views/productdetailspage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'cart_manager.dart';
import 'package:final_commerce/views/wishlist.dart';

// Define the Product model class
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

class ApiGet extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => apiState();
}

class apiState extends State<ApiGet> {
  late List<Product> products = [];
  late List<Product> wishlist = []; // Local list for wishlist
  bool isLoading = true; // Add a loading flag

  // API call to fetch products
  Future apicall() async {
    http.Response responses;
    responses = await http.get(Uri.parse("http://localhost:5555/products")); // Update the API URL accordingly

    if (responses.statusCode == 200) {
      final data = json.decode(responses.body); // Decode the JSON response
      final List<dynamic> content = data['content']; // Extract 'content' array

      setState(() {
        // Convert the list of dynamic objects into List<Product>
        products = List<Product>.from(content.map((item) => Product.fromJson(item)));
        isLoading = false; // Data fetched, set loading to false
      });
    } else {
      // Handle error
      throw Exception('Failed to load products');
    }
  }

  @override
  void initState() {
    apicall();
    super.initState();
  }

  // Function to group products in sets of 10 and add headings
  List<Widget> _buildRows(List<Product> products) {
    List<Widget> rows = [];

    for (int i = 0; i < products.length; i += 10) {
      // Slice the list to get 10 items per row
      List<Product> rowItems = products.sublist(i, i + 10 > products.length ? products.length : i + 10);

      // Add the row with items
      rows.add(SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: rowItems.map((product) {
            return GestureDetector(
              onTap: () {
                // Navigate to ProductDetailsPage when the product card is tapped
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailsPage(productId: product.id),
                  ),
                );
              },
              child: Container(
                width: 200, // Increased width to 200 for a larger size
                margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Increased margin
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          product.images.isNotEmpty ? product.images[0] : '', // Use the first image
                          width: 200, // Adjusted image width to match container size
                          height: 200, // Adjusted image height
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0), // Increased padding for better spacing
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.title,
                              style: TextStyle(fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 6),
                            Text(
                              product.description,
                              style: TextStyle(fontSize: 12),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 6), // Slightly bigger space
                            Text(
                              "\$${product.sellingPrice.toStringAsFixed(2)}",
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            // GestureDetector for Seller Details
                            GestureDetector(
                              onTap: () {
                                // Navigate to "/sellerdetails" when seller name is tapped
                                Navigator.pushNamed(context, "/sellerform");
                              },
                              child: Text(
                                "Seller: ${product.sellerName}",
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                            // Cart icon to add product to cart
                            GestureDetector(
                              // onTap: () {
                              //   CartManager.addToCart(
                              //     productId: product.id, // Correctly accessing product's ID
                              //     size: 'M', // Example size
                              //     quantity: 1, // Default quantity
                              //     token: "eyJhbGciOiJIUzM4NCJ9.eyJpYXQiOjE3MzI3NTA1MjQsImV4cCI6MTczMjgzNjkyNCwiZW1haWwiOiJzYW55YWdlcmEucHJhYmhAZ21haWwuY29tIiwiYXV0aG9yaXRpZXMiOiJST0xFX0NVU1RPTUVSIn0.4dQO9hZnaASZb0OzV1y3iFXzhCkzTRkHLz9mYXqthdHMZ0zrwF3tf101AKS9OY0d", // Replace with actual JWT token
                              //   );
                              //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Added to cart')));
                              // },
                              child: Icon(
                                Icons.shopping_cart,
                                size: 30,
                              ),
                            ),
                            // Wishlist icon to add product to wishlist
                            GestureDetector(
                              onTap: () {
                                // Add product to local wishlist list
                                setState(() {
                                  wishlist.add(product); // Add to local wishlist
                                });
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Added to Wishlist')));
                              },
                              child: Icon(
                                Icons.favorite_border,
                                size: 30,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ));
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(120),
          child: AppBar(
            backgroundColor: Colors.blueAccent,
            elevation: 0,
            flexibleSpace: Padding(
              padding: const EdgeInsets.all(8.0),
              child:
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.pushNamed(context, "/home");
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 40.0),
                      child: Column(
                        children: [
                          Text(
                            "KartFlip", // Logo text
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Explore Plus", // Explore Plus text
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search),
                              hintText: 'Search for products, brands...',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      // Profile Icon
                      IconButton(
                        icon: Icon(Icons.account_circle, size: 30, color: Colors.white),
                        onPressed: () {
                          Navigator.pushNamed(context, '/datapage'); // Redirect to profile page
                        },
                      ),
                      // Cart Icon
                      IconButton(
                        icon: Icon(Icons.shopping_cart, size: 30, color: Colors.white),
                        onPressed: () {
                          Navigator.pushNamed(context, '/cart'); // Redirect to cart page
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator()) // Show the CircularProgressIndicator when loading
            : SingleChildScrollView(child: Column(children: _buildRows(products))),
      ),
    );
  }
}
*/

/*
import 'package:final_commerce/views/productdetailspage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:final_commerce/views/wishlist.dart';

// Define the Product model class
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

class ApiGet extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => apiState();
}

class apiState extends State<ApiGet> {
  late List<Product> products = [];
  late List<Product> wishlist = []; // Local list for wishlist
  bool isLoading = true; // Add a loading flag

  // API call to fetch products
  Future apicall() async {
    http.Response responses;
    responses = await http.get(Uri.parse("http://localhost:5555/products")); // Update the API URL accordingly

    if (responses.statusCode == 200) {
      final data = json.decode(responses.body); // Decode the JSON response
      final List<dynamic> content = data['content']; // Extract 'content' array

      setState(() {
        // Convert the list of dynamic objects into List<Product>
        products = List<Product>.from(content.map((item) => Product.fromJson(item)));
        isLoading = false; // Data fetched, set loading to false
      });
    } else {
      // Handle error
      throw Exception('Failed to load products');
    }
  }

  @override
  void initState() {
    apicall();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(120),
          child: AppBar(
            backgroundColor: Colors.blueAccent,
            elevation: 0,
            flexibleSpace: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/home");
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 40.0),
                      child: Column(
                        children: [
                          Text(
                            "KartFlip", // Logo text
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Explore Plus", // Explore Plus text
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search),
                              hintText: 'Search for products, brands...',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      // Profile Icon
                      IconButton(
                        icon: Icon(Icons.account_circle, size: 30, color: Colors.white),
                        onPressed: () {
                          Navigator.pushNamed(context, '/datapage'); // Redirect to profile page
                        },
                      ),
                      // Cart Icon
                      IconButton(
                        icon: Icon(Icons.shopping_cart, size: 30, color: Colors.white),
                        onPressed: () {
                          Navigator.pushNamed(context, '/cart'); // Redirect to cart page
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.logout, size: 30, color: Colors.white),
                        onPressed: () {
                        SnackBar(
                          content: Text("Signed Out Successfully"),
                          duration: Duration(seconds: 3),
                        );
                        Navigator.pushNamed(context, "/login");
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator()) // Show the CircularProgressIndicator when loading
            : GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.75,
          ),
          itemCount: products.length, // Number of items in the grid
          itemBuilder: (context, index) {
            Product product = products[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProductDetailsPage(productId: product.id),),
                );
              },
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        product.images.isNotEmpty ? product.images[0] : '', // Use the first image
                        width: double.infinity, // Make image width fill the container
                        height: 150, // Set a fixed height for images
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.title,
                            style: TextStyle(fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 6),
                          Text(
                            product.description,
                            style: TextStyle(fontSize: 12),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 6),
                          Text(
                            "\$${product.sellingPrice.toStringAsFixed(2)}",
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          GestureDetector(
                            onTap: () {
                              // Navigate to "/sellerdetails" when seller name is tapped
                              Navigator.pushNamed(context, "/sellerform");
                            },
                            child: Text(
                              "Seller: ${product.sellerName}",
                              style: TextStyle(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
*/


/*

import 'package:final_commerce/views/productdetailspage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'cart_manager.dart'; // Import the CartManager
import 'package:final_commerce/views/wishlist.dart'; // Assuming this is required for the wishlist functionality

// Define the Product model class
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

class ApiGet extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => apiState();
}

class apiState extends State<ApiGet> {
  late List<Product> products = [];
  bool isLoading = true; // Add a loading flag

  // API call to fetch products
  Future apicall() async {
    http.Response responses;
    responses = await http.get(Uri.parse("http://localhost:5555/products")); // Update the API URL accordingly

    if (responses.statusCode == 200) {
      final data = json.decode(responses.body); // Decode the JSON response
      final List<dynamic> content = data['content']; // Extract 'content' array

      setState(() {
        // Convert the list of dynamic objects into List<Product>
        products = List<Product>.from(content.map((item) => Product.fromJson(item)));
        isLoading = false; // Data fetched, set loading to false
      });
    } else {
      // Handle error
      throw Exception('Failed to load products');
    }
  }

  @override
  void initState() {
    apicall();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(120),
          child: AppBar(
            backgroundColor: Colors.blueAccent,
            elevation: 0,
            flexibleSpace: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/home");
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 40.0),
                      child: Column(
                        children: [
                          Text(
                            "KartFlip", // Logo text
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Explore Plus", // Explore Plus text
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search),
                              hintText: 'Search for products, brands...',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      // Profile Icon
                      IconButton(
                        icon: Icon(Icons.account_circle, size: 30, color: Colors.white),
                        onPressed: () {
                          Navigator.pushNamed(context, '/datapage'); // Redirect to profile page
                        },
                      ),
                      // Cart Icon
                      IconButton(
                        icon: Icon(Icons.shopping_cart, size: 30, color: Colors.white),
                        onPressed: () {
                          Navigator.pushNamed(context, '/cart'); // Redirect to cart page
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.logout, size: 30, color: Colors.white),
                        onPressed: () {
                          SnackBar(
                            content: Text("Signed Out Successfully"),
                            duration: Duration(seconds: 3),
                          );
                          Navigator.pushNamed(context, "/login");
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator()) // Show the CircularProgressIndicator when loading
            : GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.75,
          ),
          itemCount: products.length, // Number of items in the grid
          itemBuilder: (context, index) {
            Product product = products[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailsPage(productId: product.id),
                  ),
                );
              },
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        product.images.isNotEmpty ? product.images[0] : '', // Use the first image
                        width: double.infinity, // Make image width fill the container
                        height: 150, // Set a fixed height for images
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.title,
                            style: TextStyle(fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 6),
                          Text(
                            product.description,
                            style: TextStyle(fontSize: 12),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 6),
                          Text(
                            "\$${product.sellingPrice.toStringAsFixed(2)}",
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          // Add to Cart Button
                          GestureDetector(
                            onTap: () {
                              CartManager.addToCart(product); // Add the product to the cart
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('${product.title} added to cart')),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Add to Cart',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
*/

/*
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'cart_manager.dart'; // Import the CartManager
import 'package:final_commerce/views/productdetailspage.dart'; // Assuming this is required for product details page

// Define the Product model class
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

class ApiGet extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ApiGetState();
}

class _ApiGetState extends State<ApiGet> {
  late List<Product> products = [];
  bool isLoading = true; // Add a loading flag

  // API call to fetch products
  Future apicall() async {
    http.Response responses;
    responses = await http.get(Uri.parse("http://localhost:5555/products")); // Update the API URL accordingly

    if (responses.statusCode == 200) {
      final data = json.decode(responses.body); // Decode the JSON response
      final List<dynamic> content = data['content']; // Extract 'content' array

      setState(() {
        // Convert the list of dynamic objects into List<Product>
        products = List<Product>.from(content.map((item) => Product.fromJson(item)));
        isLoading = false; // Data fetched, set loading to false
      });
    } else {
      // Handle error
      throw Exception('Failed to load products');
    }
  }

  @override
  void initState() {
    apicall();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(120),
          child: AppBar(
            backgroundColor: Colors.blueAccent,
            elevation: 0,
            flexibleSpace: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/home");
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 40.0),
                      child: Column(
                        children: [
                          Text(
                            "KartFlip", // Logo text
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Explore Plus", // Explore Plus text
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search),
                              hintText: 'Search for products, brands...',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.account_circle, size: 30, color: Colors.white),
                        onPressed: () {
                          Navigator.pushNamed(context, '/datapage'); // Redirect to profile page
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.shopping_cart, size: 30, color: Colors.white),
                        onPressed: () {
                          Navigator.pushNamed(context, '/cart'); // Redirect to cart page
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.logout, size: 30, color: Colors.white),
                        onPressed: () {
                          SnackBar(
                            content: Text("Signed Out Successfully"),
                            duration: Duration(seconds: 3),
                          );
                          Navigator.pushNamed(context, "/login");
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator()) // Show the CircularProgressIndicator when loading
            : GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.75,
          ),
          itemCount: products.length, // Number of items in the grid
          itemBuilder: (context, index) {
            Product product = products[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailsPage(productId: product.id),
                  ),
                );
              },
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        product.images.isNotEmpty ? product.images[0] : '', // Use the first image
                        width: double.infinity, // Make image width fill the container
                        height: 150, // Set a fixed height for images
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.title,
                            style: TextStyle(fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 6),
                          Text(
                            product.description,
                            style: TextStyle(fontSize: 12),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 6),
                          Text(
                            "\$${product.sellingPrice.toStringAsFixed(2)}",
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          // Add to Cart Button
                          GestureDetector(
                            onTap: () {
                              CartManager.addToCart(product); // Add the product to the cart
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('${product.title} added to cart')),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Add to Cart',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
*/
/*

import 'package:final_commerce/views/productdetailspage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:final_commerce/views/wishlist.dart';

// Define the Product model class
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

class ApiGet extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => apiState();
}

class apiState extends State<ApiGet> {
  late List<Product> products = [];
  late List<Product> wishlist = []; // Local list for wishlist
  bool isLoading = true; // Add a loading flag

  // API call to fetch products
  Future apicall() async {
    http.Response responses;
    responses = await http.get(Uri.parse("http://localhost:5555/products")); // Update the API URL accordingly

    if (responses.statusCode == 200) {
      final data = json.decode(responses.body); // Decode the JSON response
      final List<dynamic> content = data['content']; // Extract 'content' array

      setState(() {
        // Convert the list of dynamic objects into List<Product>
        products = List<Product>.from(content.map((item) => Product.fromJson(item)));
        isLoading = false; // Data fetched, set loading to false
      });
    } else {
      // Handle error
      throw Exception('Failed to load products');
    }
  }

  @override
  void initState() {
    apicall();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(120),
          child: AppBar(
            backgroundColor: Colors.blueAccent,
            elevation: 0,
            flexibleSpace: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/home");
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 40.0),
                      child: Column(
                        children: [
                          Text(
                            "KartFlip", // Logo text
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Explore Plus", // Explore Plus text
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search),
                              hintText: 'Search for products, brands...',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      // Profile Icon
                      IconButton(
                        icon: Icon(Icons.account_circle, size: 30, color: Colors.white),
                        onPressed: () {
                          Navigator.pushNamed(context, '/datapage'); // Redirect to profile page
                        },
                      ),
                      // Cart Icon
                      IconButton(
                        icon: Icon(Icons.shopping_cart, size: 30, color: Colors.white),
                        onPressed: () {
                          Navigator.pushNamed(context, '/cart'); // Redirect to cart page
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.logout, size: 30, color: Colors.white),
                        onPressed: () {
                          SnackBar(
                            content: Text("Signed Out Successfully"),
                            duration: Duration(seconds: 3),
                          );
                          Navigator.pushNamed(context, "/login");
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator()) // Show the CircularProgressIndicator when loading
            : GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.75,
          ),
          itemCount: products.length, // Number of items in the grid
          itemBuilder: (context, index) {
            Product product = products[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProductDetailsPage(productId: product.id),),
                );
              },
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        product.images.isNotEmpty ? product.images[0] : '', // Use the first image
                        width: double.infinity, // Make image width fill the container
                        height: 150, // Set a fixed height for images
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.title,
                            style: TextStyle(fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 6),
                          Text(
                            product.description,
                            style: TextStyle(fontSize: 12),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 6),
                          Text(
                            "\$${product.sellingPrice.toStringAsFixed(2)}",
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          GestureDetector(
                            onTap: () {
                              // Navigate to "/sellerdetails" when seller name is tapped
                              Navigator.pushNamed(context, "/sellerform");
                            },
                            child: Text(
                              "Seller: ${product.sellerName}",
                              style: TextStyle(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
*/

/*
import 'package:final_commerce/views/productdetailspage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
      sellerName: json['seller']['sellerName'], // Nested object for seller
    );
  }
}

class ApiGet extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => apiState();
}

class apiState extends State<ApiGet> {
  late List<Product> products = [];
  bool isLoading = false;
  bool hasMore = true;
  int currentPage = 2;
  int limit = 10;


  Future<void> apicall() async {
    if (isLoading || !hasMore) return;
    setState(() {
      isLoading = true;
    });

    final url = "http://localhost:5555/products?page=$currentPage&limit=$limit"; // Updated URL for pagination
    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> content = data['content'];

      setState(() {
        // Convert the list of dynamic objects into List<Product>
        products.addAll(content.map((item) => Product.fromJson(item)).toList());
        isLoading = false;
        if (content.length < limit) {
          hasMore = false;
        } else {
          currentPage++;
        }
      });
    } else {
      // Handle error
      throw Exception('Failed to load products');
    }
  }

  @override
  void initState() {
    super.initState();
    apicall(); // Fetch the first page of products
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(120),
          child: AppBar(
            backgroundColor: Colors.blueAccent,
            elevation: 0,
            flexibleSpace: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/home");
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 40.0),
                      child: Column(
                        children: [
                          Text(
                            "KartFlip", // Logo text
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Explore Plus", // Explore Plus text
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.search),
                                      hintText: 'Search for products, brands...',
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                              // Profile Icon
                              IconButton(
                                icon: Icon(Icons.account_circle, size: 30, color: Colors.white),
                                onPressed: () {
                                  Navigator.pushNamed(context, '/datapage'); // Redirect to profile page
                                },
                              ),
                              // Cart Icon
                              IconButton(
                                icon: Icon(Icons.shopping_cart, size: 30, color: Colors.white),
                                onPressed: () {
                                  Navigator.pushNamed(context, '/cart'); // Redirect to cart page
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.logout, size: 30, color: Colors.white),
                                onPressed: () {
                                  SnackBar(
                                    content: Text("Signed Out Successfully"),
                                    duration: Duration(seconds: 3),
                                  );
                                  Navigator.pushNamed(context, "/login");
                                },
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: isLoading && products.isEmpty
            ? Center(child: CircularProgressIndicator()) // Show the CircularProgressIndicator when loading
            : NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            if (scrollNotification is ScrollEndNotification &&
                scrollNotification.metrics.pixels == scrollNotification.metrics.maxScrollExtent) {
              // If the user has scrolled to the bottom, load more products
              apicall();
            }
            return false;
          },
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.75,
            ),
            itemCount: products.length, // Number of items in the grid
            itemBuilder: (context, index) {
              Product product = products[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProductDetailsPage(productId: product.id)),
                  );
                },
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          product.images.isNotEmpty ? product.images[0] : '',
                          width: double.infinity,
                          height: 150,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.title,
                              style: TextStyle(fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 6),
                            Text(
                              product.description,
                              style: TextStyle(fontSize: 12),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 6),
                            Text(
                              "\$${product.sellingPrice.toStringAsFixed(2)}",
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, "/sellerform");
                              },
                              child: Text(
                                "Seller: ${product.sellerName}",
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
      .cast<Map<String, dynamic>>()          ),
              );
            },
          ),
        ),
      ),
    );
  }
}
*/

import 'package:final_commerce/views/productdetailspage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
      sellerName: json['seller']['sellerName'], // Nested object for seller
    );
  }
}

class ApiGet extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => apiState();
}

class apiState extends State<ApiGet> {
  late List<Product> products = [];  // Main products list
  late List<Product> duplicatedProducts = [];  // Duplicate list for displaying filtered results
  bool isLoading = false;
  bool hasMore = true;
  int currentPage = 2;
  int limit = 10;
  String searchQuery = '';  // Store the search query for filtering

  // API call to fetch products (pagination)
  Future<void> apicall() async {
    if (isLoading || !hasMore) return;
    setState(() {
      isLoading = true;
    });

    final url = "http://localhost:5555/products?page=$currentPage&limit=$limit"; // Updated URL for pagination
    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      try {
        final data = json.decode(response.body); // Decode the response
        final List<dynamic> content = data['content']; // Make sure 'content' is a list

        setState(() {
          // Convert the list of dynamic objects into List<Product>
          List<Product> newProducts = content.map((item) => Product.fromJson(item)).toList();
          products.addAll(newProducts);
          duplicatedProducts.addAll(newProducts); // Duplicate the products list
          isLoading = false;
          if (content.length < limit) {
            hasMore = false;
          } else {
            currentPage++;
          }
        });
      } catch (e) {
        print("Error decoding response: $e");
        // Handle error in decoding response
        throw Exception('Failed to load products');
      }
    } else {
      throw Exception('Failed to load products');
    }
  }

  // Search functionality that queries based on the title
  Future<void> runSearch(String query) async {
    setState(() {
      searchQuery = query; // Update search query
    });

    if (query.isEmpty) {
      // If search is empty, display all products
      setState(() {
        duplicatedProducts = List.from(products);
      });
    } else {
      // If search query is entered, make an API call to search by title
      final url = "http://localhost:5555/products/search?query=$query"; // API that filters by title
      http.Response response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        try {
          final data = json.decode(response.body); // Decode the response
          final List<dynamic> content = data['content']; // Ensure 'content' is a list

          setState(() {
            duplicatedProducts = content.map((item) => Product.fromJson(item)).toList();
          });
        } catch (e) {
          print("Error decoding response: $e");
          // Handle error in decoding response
          throw Exception('Failed to search products');
        }
      } else {
        throw Exception('Failed to search products');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    apicall(); // Fetch the first page of products
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(120),
          child: AppBar(
            backgroundColor: Colors.blueAccent,
            elevation: 0,
            flexibleSpace: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/home");
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 40.0),
                      child: Column(
                        children: [
                          Text(
                            "KartFlip", // Logo text
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Explore Plus", // Explore Plus text
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: TextField(
                                    onChanged: (value) => runSearch(value), // Search functionality on change
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.search),
                                      hintText: 'Search for products, brands...',
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                              // Profile Icon
                              IconButton(
                                icon: Icon(Icons.account_circle, size: 30, color: Colors.white),
                                onPressed: () {
                                  Navigator.pushNamed(context, '/datapage'); // Redirect to profile page
                                },
                              ),
                              // Cart Icon
                              IconButton(
                                icon: Icon(Icons.shopping_cart, size: 30, color: Colors.white),
                                onPressed: () {
                                  Navigator.pushNamed(context, '/cart'); // Redirect to cart page
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.logout, size: 30, color: Colors.white),
                                onPressed: () {
                                  SnackBar(
                                    content: Text("Signed Out Successfully"),
                                    duration: Duration(seconds: 3),
                                  );
                                  Navigator.pushNamed(context, "/login");
                                },
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: isLoading && products.isEmpty
            ? Center(child: CircularProgressIndicator()) // Show the CircularProgressIndicator when loading
            : NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            if (scrollNotification is ScrollEndNotification &&
                scrollNotification.metrics.pixels == scrollNotification.metrics.maxScrollExtent) {
              // If the user has scrolled to the bottom, load more products
              apicall();
            }
            return false;
          },
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.75,
            ),
            itemCount: duplicatedProducts.length, // Display items from the duplicated list
            itemBuilder: (context, index) {
              Product product = duplicatedProducts[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProductDetailsPage(productId: product.id)),
                  );
                },
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          product.images.isNotEmpty ? product.images[0] : '',
                          width: double.infinity,
                          height: 150,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.title,
                              style: TextStyle(fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 6),
                            Text(
                              product.description,
                              style: TextStyle(fontSize: 12),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 6),
                            Text(
                              "\$${product.sellingPrice.toStringAsFixed(2)}",
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, "/sellerform");
                              },
                              child: Text(
                                "Sold by ${product.sellerName}",
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
