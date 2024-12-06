import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(PreviousUsers());
}

class PreviousUsers extends StatefulWidget {
  @override
  _PreviousUsersAppState createState() => _PreviousUsersAppState();
}

class _PreviousUsersAppState extends State<PreviousUsers> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Previous Users data',
      home: UserListScreen(),
    );
  }
}

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  List<dynamic> users = [];

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    final response = await http.get(Uri.parse('https://reqres.in/api/users'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        users = data['data']; // Extracting the 'data' array from the response
      });
    } else {
      // Error handling
      throw Exception('Failed to load users');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Previous User Details'),
        backgroundColor: Colors.blueAccent,
      ),
      body: users.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return
            Card(
              margin: EdgeInsets.all(10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 5,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(user['avatar']),
                  radius: 30,
                ),
                title: Text(
                  '${user['first_name']} ${user['last_name']}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                subtitle: Text(
                  user['email'],
                  style: TextStyle(color: Colors.grey[600]),
                ),
                trailing: Text(
                  'ID: ${user['id']}',
                  style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                ),
              ),
            );
        },
      ),
    );
  }
}
