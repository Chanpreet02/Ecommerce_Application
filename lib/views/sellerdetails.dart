import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SellerDetailsPage extends StatefulWidget {
  @override
  _SellerDetailsPageState createState() => _SellerDetailsPageState();
}

class _SellerDetailsPageState extends State<SellerDetailsPage> {
  late Map<String, dynamic> sellerDetails;
  bool isLoading = true;  // Add a loading flag to manage the CircularProgressIndicator

  @override
  void initState() {
    super.initState();
    // Fetch the seller details once the page loads
    _fetchSellerDetails();
  }

  // Function to fetch seller details using the JWT token
  Future<void> _fetchSellerDetails() async {
    final token = "eyJhbGciOiJIUzM4NCJ9.eyJpYXQiOjE3MzI3NTY1ODcsImV4cCI6MTczMjg0Mjk4NywiZW1haWwiOiJzaW1yZWV0a2F1cjIwMDhAZ21haWwuY29tIiwiYXV0aG9yaXRpZXMiOiJST0xFX0NVU1RPTUVSIn0.xv-DeMZU7Qev2is_Mh7GD5TKs4bvjRQgtedGc43lIBfflXcipnmMNK4x-Rod4Qp3"; // JWT token

    try {
      final response = await http.get(
        Uri.parse('http://localhost:5555/sellers/profile'), // Seller profile API
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token", // Pass JWT token in the Authorization header
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          sellerDetails = data; // Store the seller details
          isLoading = false;  // Set loading flag to false once data is fetched
        });
      } else {
        setState(() {
          isLoading = false;  // Set loading flag to false if API call fails
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: ${response.statusCode}")));
      }
    } catch (e) {
      setState(() {
        isLoading = false;  // Set loading flag to false if an error occurs
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Seller Details')),
      body: isLoading  // Show CircularProgressIndicator while loading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Seller Name
            Text(
              sellerDetails['sellerName'] ?? 'No Name',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            // Seller Mobile
            Text(
              'Mobile: ${sellerDetails['mobile'] ?? 'No Mobile'}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),

            // Seller Email
            Text(
              'Email: ${sellerDetails['email'] ?? 'No Email'}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),

            // Business Details Section
            if (sellerDetails['businessDetails'] != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Business Details', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text('Business Name: ${sellerDetails['businessDetails']['businessName'] ?? 'N/A'}'),
                  Text('Business Email: ${sellerDetails['businessDetails']['businessEmail'] ?? 'N/A'}'),
                  Text('Business Mobile: ${sellerDetails['businessDetails']['businessMobile'] ?? 'N/A'}'),
                  Text('Business Address: ${sellerDetails['businessDetails']['businessAddress'] ?? 'N/A'}'),
                  Text('Business Logo URL: ${sellerDetails['businessDetails']['logo'] ?? 'N/A'}'),
                  Text('Business Banner URL: ${sellerDetails['businessDetails']['banner'] ?? 'N/A'}'),
                  SizedBox(height: 20),
                ],
              ),

            // Bank Details Section
            if (sellerDetails['bankDetails'] != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Bank Details', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text('Account Number: ${sellerDetails['bankDetails']['accountNumber'] ?? 'N/A'}'),
                  Text('Account Holder Name: ${sellerDetails['bankDetails']['accountHolderName'] ?? 'N/A'}'),
                  Text('IFSC Code: ${sellerDetails['bankDetails']['ifscCode'] ?? 'N/A'}'),
                  SizedBox(height: 20),
                ],
              ),

            // Pickup Address Section
            if (sellerDetails['pickupAddress'] != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Pickup Address', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text('Name: ${sellerDetails['pickupAddress']['name'] ?? 'N/A'}'),
                  Text('Locality: ${sellerDetails['pickupAddress']['locality'] ?? 'N/A'}'),
                  Text('City: ${sellerDetails['pickupAddress']['city'] ?? 'N/A'}'),
                  Text('State: ${sellerDetails['pickupAddress']['state'] ?? 'N/A'}'),
                  Text('Pin Code: ${sellerDetails['pickupAddress']['pinCode'] ?? 'N/A'}'),
                  SizedBox(height: 20),
                ],
              ),

            // Additional Seller Info Section
            Text('Role: ${sellerDetails['role'] ?? 'N/A'}', style: TextStyle(fontSize: 18)),
            Text('Account Status: ${sellerDetails['accountStatus'] ?? 'N/A'}', style: TextStyle(fontSize: 18)),
            Text('Email Verified: ${sellerDetails['emailVerified'] ? 'Yes' : 'No'}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
