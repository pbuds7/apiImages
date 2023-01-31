import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:swipe_deck/swipe_deck.dart';

class Personaje {}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();

}


class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> users = [];
  print('rendering');
  var IMAGES = [];
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Presentación Imágenes de API'),
      ),
      body: Center(
        child: Container(
          width: 600,
          child: Center(
            child: SwipeDeck(
              startIndex: 3,
              emptyIndicator: Container(
                child: Center(
                  child: Text("Nothing Here"),
                ),
              ),
              cardSpreadInDegrees: 5, // Change the Spread of Background Cards
              onSwipeLeft: () {
                print("USER SWIPED LEFT -> GOING TO NEXT WIDGET");
              },
              onSwipeRight: () {
                print("USER SWIPED RIGHT -> GOING TO PREVIOUS WIDGET");
              },
              onChange: (index) {
                print(IMAGES[index]);
              },
              widgets: IMAGES
                  .map((e) => GestureDetector(
                        onTap: () {
                          print(e);
                        },
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: Image.network(
                              '$e',
                              fit: BoxFit.cover,
                            )),
                      ))
                  .toList(),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: fetchUsers,
        label: const Text('Mostrar Personajes'),
      ),
    );
  }

  void fetchUsers() async {
    print('fetchUsers called');
    try {
      const url = 'https://rickandmortyapi.com/api/character';
      final uri = Uri.parse(url);
      final response = await http.get(uri);
      switch (response.statusCode) {
        case 200:
          final body = response.body;
          final json = jsonDecode(body);
          setState(() {
            users = json['results'];
            for (var character in users) {
              final imageUrl = character['image'].toString();
              IMAGES.add(imageUrl);
            }
          });
          print('fetchUsers completed');
          print(IMAGES);
          break;
        default:
          print('Erorr de conexión 1');
      }
    } catch (e) {
      print('Error de conexión 2');
    }
  }
}
