import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> users = [];

  /// Fetch Users from API
  Future<void> fetchUsers() async {
    const url = 'https://randomuser.me/api/?results=20';
    final uri = Uri.parse(url);

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        setState(() {
          users = json['results'];
        });
        print("[INFO] Users fetched successfully.");
      } else {
        print(
          "[ERROR] Failed to load users. Status Code: ${response.statusCode}",
        );
      }
    } catch (e) {
      print("[ERROR] Exception: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("User List")),
      body:
          users.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  final name =
                      '${user['name']['first']} ${user['name']['last']}';
                  final email = user['email'];
                  final image = user['picture']['thumbnail'];

                  return ListTile(
                    leading: CircleAvatar(backgroundImage: NetworkImage(image)),
                    title: Text(name),
                    subtitle: Text(email),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchUsers,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
