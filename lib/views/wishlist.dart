/*
import 'package:flutter/material.dart';
import '../models/product.dart';


class WishlistPage extends StatelessWidget {
  List<Product> wishlist;

  // Constructor to receive the wishlist
  WishlistPage({required this.wishlist});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Your Wishlist"),
          backgroundColor: Colors.blueAccent,
        ),
        body: wishlist.isEmpty
            ? Center(child: Text("Your wishlist is empty."))
            : ListView.builder(
          itemCount: wishlist.length,
          itemBuilder: (context, index) {
            final product = wishlist[index];
            // bottomNavigationBar: BottomAppBar(
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       IconButton(
            //         icon: Icon(Icons.home),
            //         onPressed: () {
            //           Navigator.pushReplacementNamed(context, '/home');
            //         },
            //       ),
            //       IconButton(
            //         icon: Icon(Icons.favorite),
            //         onPressed: () {
            //           // Navigate to the WishlistPage
            //           Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //               builder: (context) => WishlistPage(wishlist: []),
            //             ),
            //           );
            //         },
            //       ),
            //       IconButton(
            //         icon: Icon(Icons.shopping_cart),
            //         onPressed: () {
            //           Navigator.pushNamed(context, "/cart");
            //         },
            //       ),
            //     ],
            //   ),
            // );
            return Card(
              margin: EdgeInsets.all(12),
              child: ListTile(
                contentPadding: EdgeInsets.all(10),
                leading: Image.network(
                  product.images.isNotEmpty
                      ? product.images[0]
                      : 'https://via.placeholder.com/150', // Placeholder if no image
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
                title: Text(product.title),
                subtitle: Text("\$${product.sellingPrice.toStringAsFixed(2)}"),
              ),
            );
          },
        ),
      ),
    );
  }
}
*/

import 'package:flutter/material.dart';
import 'package:final_commerce/views/productdetailspage.dart'; // Import ProductDetailsPage

class WishlistPage extends StatelessWidget {
  final List<Product> wishlist;

  WishlistPage({required this.wishlist});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Wishlist"),
        backgroundColor: Colors.blueAccent,
      ),
      body: wishlist.isEmpty
          ? Center(child: Text("No products in the wishlist"))
          : ListView.builder(
        itemCount: wishlist.length,
        itemBuilder: (context, index) {
          final product = wishlist[index];
          return GestureDetector(
            onTap: () {
              // Navigate to product details
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailsPage(productId: product.id),
                ),
              );
            },
            child: ListTile(
              title: Text(product.title),
              subtitle: Text("\$${product.sellingPrice.toStringAsFixed(2)}"),
              leading: Image.network(
                product.images.isNotEmpty ? product.images[0] : '',
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}
