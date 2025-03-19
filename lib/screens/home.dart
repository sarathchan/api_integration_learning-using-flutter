import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Import dart:convert for jsonDecode

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> users = [];

  /// Fetch Users Function
  Future<void> fetchUsers() async {
    const url = 'https://randomuser.me/api/?results=50';
    final uri = Uri.parse(url);

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final body = response.body;
        final json = jsonDecode(body);

        setState(() {
          users = json['results'];
        });
        print(users);
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("User List")),
      body:
          users.isEmpty
              ? const Center(child: Text("No Users Found"))
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
