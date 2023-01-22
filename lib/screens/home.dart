import 'dart:math';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consumo de API Desarrollo Móvil'),
      ),
      body: ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            final name = user['name']['first'];
            final city = user['location']['city'];
            final country = user['location']['country'];
            final imageUrl = user['picture']['thumbnail'];
            final age = user['dob']['age'];
            return ListTile(
              leading: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.network(imageUrl)),
              title: Text(name),
              subtitle: Text('$city, $country, $age'),
            );
          }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: fetchUsers,
        label: const Text('Importar candidatos'),
      ),
    );
  }

  void fetchUsers() async {
    print('fetchUsers called');
    try {
      const url = 'https://randomuser.me/api/?results=10';
      final uri = Uri.parse(url);
      final response = await http.get(uri);
      switch (response.statusCode) {
        case 200:
          final body = response.body;
          final json = jsonDecode(body);
          setState(() {
            users = json['results'];
          });
          print('fetchUsers completed');
          break;
        default:
          throw Exception(e);
      }
    } catch (e) {
      print('Error de conexión');
    }
  }
}
