/*
import 'package:final_commerce/views/wishlist.dart';
import 'package:flutter/material.dart';
import 'cart_manager.dart';


class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<CartItem> cartItems = CartManager.getCartItems();
    double totalPrice = CartManager.getTotal();

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
        backgroundColor: Colors.blueAccent,
      ),
      body: cartItems.isEmpty
          ? Center(child: Text('Your cart is empty'))
          : ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          CartItem item = cartItems[index];
          return ListTile(
            leading: Image.network(item.imageUrl, width: 50, height: 50),
            title: Text(item.title),
            subtitle: Text('Size: ${item.size} | Quantity: ${item.quantity}'),
            trailing: Text('\$${(item.sellingPrice * item.quantity).toStringAsFixed(2)}'),
          );
        },
      ),
      bottomNavigationBar: cartItems.isEmpty
          ? null
          : Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Total: \$${totalPrice.toStringAsFixed(2)}'),
            ElevatedButton(
              onPressed: () {
                // Implement checkout functionality
              },
              child: Text('Checkout'),
            ),
          ],
        ),
      ),
    );
  }
}
*/
/*

import 'package:flutter/material.dart';
import '../models/product.dart';

// Cart Manager class
class CartManager {
  static List<CartItem> cartItems = [];

  static void addToCart(Product product) {
    CartItem? existingItem = cartItems.firstWhere(
          (item) => item.product.id == product.id,
      orElse: () => CartItem(product: product),
    );

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
    CartItem item = cartItems.firstWhere((item) => item.product.id == product.id);
    item.quantity = newQuantity;
  }

  static double getTotal() {
    return cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
  }
}

// CartItem model
class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  int get totalPrice => product.sellingPrice * quantity;
}

// Cart Page to display Cart Items
class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: CartManager.cartItems.isEmpty
          ? Center(child: Text('Your cart is empty'))
          : ListView.builder(
        itemCount: CartManager.cartItems.length,
        itemBuilder: (context, index) {
          final cartItem = CartManager.cartItems[index];

          return ListTile(
            title: Text(cartItem.product.title),
            subtitle: Text('Price: \$${cartItem.product.sellingPrice.toStringAsFixed(2)}'),
            trailing: Text('\$${cartItem.totalPrice.toStringAsFixed(2)}'),
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Decrease quantity button
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    if (cartItem.quantity > 1) {
                      CartManager.updateQuantity(cartItem.product, cartItem.quantity - 1);
                    }
                  },
                ),
                // Quantity display
                Text(cartItem.quantity.toString()),
                // Increase quantity button
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    CartManager.updateQuantity(cartItem.product, cartItem.quantity + 1);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
*/
/*
import 'package:final_commerce/views/productdetailspage.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';


class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Consumer<CartManager>(
        builder: (context, cartManager, _) {
          return CartManager.cartItems.isEmpty
              ? Center(child: Text('Your cart is empty'))
              : ListView.builder(
            itemCount: CartManager.cartItems.length,
            itemBuilder: (context, index) {
              final cartItem = CartManager.cartItems[index];

              return ListTile(
                title: Text(cartItem.product.title),
                subtitle: Text('Price: \$${cartItem.product.sellingPrice.toStringAsFixed(2)}'),
                trailing: Text('\$${cartItem.totalPrice.toStringAsFixed(2)}'),
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Decrease quantity button
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        if (cartItem.quantity > 1) {
                          CartManager.updateQuantity(cartItem.product, cartItem.quantity - 1);
                        }
                      },
                    ),
                    // Quantity display
                    Text(cartItem.quantity.toString()),
                    // Increase quantity button
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        CartManager.updateQuantity(cartItem.product, cartItem.quantity + 1);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
*/


import 'package:final_commerce/views/productdetailspage.dart';
import 'package:flutter/material.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double totalAmount = CartManager.getTotal(); // Calculate the total amount

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: CartManager.cartItems.isEmpty
          ? Center(child: Text('Your cart is empty')) // Keep this condition if you still want to show a message when cart is empty
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // List of cart items
            Expanded(
              child: ListView.builder(
                itemCount: CartManager.cartItems.length,
                itemBuilder: (context, index) {
                  final cartItem = CartManager.cartItems[index];

                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          // Product Image (optional)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              cartItem.product.images.isNotEmpty
                                  ? cartItem.product.images[0]
                                  : '',
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 16),
                          // Product Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  cartItem.product.title,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Price: \$${cartItem.product.sellingPrice.toStringAsFixed(2)}',
                                  style: TextStyle(fontSize: 14),
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    // Decrease quantity button
                                    IconButton(
                                      icon: Icon(Icons.remove),
                                      onPressed: () {
                                        if (cartItem.quantity > 1) {
                                          CartManager.updateQuantity(
                                            cartItem.product,
                                            cartItem.quantity - 1,
                                          );
                                        }
                                      },
                                    ),
                                    // Quantity display
                                    Text(cartItem.quantity.toString()),
                                    // Increase quantity button
                                    IconButton(
                                      icon: Icon(Icons.add),
                                      onPressed: () {
                                        CartManager.updateQuantity(
                                          cartItem.product,
                                          cartItem.quantity + 1,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // Total price for the current item
                          Text(
                            '\$${cartItem.totalPrice.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            // Total Amount Section
            Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Amount:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '\$${totalAmount.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            // Checkout Button
            ElevatedButton(
              onPressed: () {
                // Add your checkout action here
              },
              child: Text('Proceed to Checkout'),
              style: ElevatedButton.styleFrom(
                // primary: Colors.blueAccent,
                padding: EdgeInsets.symmetric(vertical: 16),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
