import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VerifyOtpPage extends StatefulWidget {
  final String email;

  VerifyOtpPage({required this.email});

  @override
  State<VerifyOtpPage> createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _otpController = TextEditingController();
  String? jwtToken;

  // Function to handle the POST request to verify OTP and sign up
  Future<void> _verifyOtpAndSignup() async {
    final fullName = _fullNameController.text;
    final otp = _otpController.text;

    if (fullName.isEmpty || otp.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill in all fields")));
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://localhost:5555/auth/signup'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "fullName": fullName,
          "email": widget.email,
          "otp": otp,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        // Assuming the JWT token is returned in the response
        jwtToken = responseData['jwt'];

        // Store JWT token for future use
        // You can use shared_preferences or any other method to store it persistently
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Signup Successful!")));

        // Navigate to the home screen or dashboard
        Navigator.pushReplacementNamed(context, "/home");
      } else {
        // If the server returns an error
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: ${response.statusCode}")));
      }
    } catch (e) {
      // If there is an exception
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              SizedBox(height: 120),
              SizedBox(
                width: MediaQuery.of(context).size.width * .9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Verify OTP",
                      style: TextStyle(fontSize: 40, fontWeight: FontWeight.w700),
                    ),
                    Text("Enter your details and OTP"),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _fullNameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text("Full Name"),
                      ),
                      validator: (value) => value!.isEmpty ? "Full Name cannot be empty." : null,
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _otpController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text("OTP"),
                      ),
                      validator: (value) => value!.isEmpty ? "OTP cannot be empty." : null,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _verifyOtpAndSignup,
                child: Text("Verify OTP and Sign Up"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
