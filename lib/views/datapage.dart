import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DataPage extends StatefulWidget {
  const DataPage({Key? key}) : super(key: key);

  @override
  _DataPageState createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  var data; // Variable to store the fetched data
  bool isLoading = true; // For loading state

  // The Bearer Token (Example)
  String bearerToken = "eyJhbGciOiJIUzM4NCJ9.eyJpYXQiOjE3MzI3NTA1MjQsImV4cCI6MTczMjgzNjkyNCwiZW1haWwiOiJzYW55YWdlcmEucHJhYmhAZ21haWwuY29tIiwiYXV0aG9yaXRpZXMiOiJST0xFX0NVU1RPTUVSIn0.4dQO9hZnaASZb0OzV1y3iFXzhCkzTRkHLz9mYXqthdHMZ0zrwF3tf101AKS9OY0d";

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  // Function to fetch protected data
  Future<void> _fetchData() async {
    final Uri apiUrl = Uri.parse('http://localhost:5555/users/profile'); // Replace with your API URL

    try {
      final response = await http.get(
        apiUrl,
        headers: {
          'Authorization': 'Bearer $bearerToken', // Include the Bearer token
          'Content-Type': 'application/json',     // Optional, if the API expects it
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          data = json.decode(response.body); // Assuming the response is JSON
          isLoading = false;
        });
      } else {
        // If the server returns an error, handle it
        setState(() {
          data = 'Error: ${response.statusCode}';
          isLoading = false;
        });
        // Show error message using Snackbar
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Failed to fetch data: ${response.statusCode}"),
          duration: Duration(seconds: 3),
        ));
      }
    } catch (e) {
      // Handle any other errors (network, parsing issues, etc.)
      setState(() {
        data = 'Error: $e';
        isLoading = false;
      });
      // Show error message using Snackbar
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error: $e"),
        duration: Duration(seconds: 3),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display loading indicator or fetched data
            isLoading
                ? Center(child: CircularProgressIndicator())
                : data != null
                ? Expanded(
              child: ListView(
                children: [
                  // Display user information in a beautified way
                  _buildUserInfoCard("Full Name", data['fullName'] ?? 'N/A', Icons.person),
                  _buildUserInfoCard("Email", data['email'] ?? 'N/A', Icons.email),
                  _buildUserInfoCard("Mobile Number", data['mobile'] ?? 'N/A', Icons.phone),
                  _buildUserInfoCard("Role", data['role'] ?? 'N/A', Icons.business),
                ],
              ),
            )
                : Center(child: Text('Failed to fetch data')),
          ],
        ),
      ),
    );
  }

  // Helper method to build a Card widget for displaying user info
  Widget _buildUserInfoCard(String title, String value, IconData icon) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(icon, color: Colors.blueAccent),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(value),
      ),
    );
  }
}
