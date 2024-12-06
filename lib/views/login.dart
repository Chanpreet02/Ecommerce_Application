import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controllers for the input fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  bool _isLoading = false; // To manage loading state

  // Function to handle login request
  Future<void> _login() async {
    setState(() {
      _isLoading = true; // Start loading
    });

    final String email = _emailController.text;
    final String otp = _otpController.text;

    try {
      final response = await http.post(
        Uri.parse('http://localhost:5555/auth/signIn'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email': email,
          'otp': otp,
        }),
      );

      setState(() {
        _isLoading = false; // Stop loading
      });

      if (response.statusCode == 200) {
        // Successful login
        final data = json.decode(response.body);
        final message = data['message'] ?? 'Login Successful';
        final role = data['role'] ?? 'N/A';

        // Show a snackbar with the login message and role
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Message: $message\nRole: $role')),
        );

        // Navigate to the home page
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // Handle errors from API (incorrect OTP or email)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.statusCode} Invalid Credentials')),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false; // Stop loading in case of an error
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Email TextField
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),

            // OTP TextField
            TextField(
              controller: _otpController,
              decoration: InputDecoration(
                labelText: 'OTP',
                hintText: 'Enter your OTP',
                border: OutlineInputBorder(),
              ),
              obscureText: true, // For OTP, it can be hidden
            ),
            SizedBox(height: 20),

            // Login Button
            TextButton(
              onPressed: _isLoading ? null : _login, // Disable button while loading
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Login'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15),  // Button color
              ),
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account"),
                TextButton(onPressed: (){Navigator.pushNamed(context, "/signup");}, child: Text("Sign Up here"))
              ],
            ),

          ],
        ),
      ),
    );
  }
}
