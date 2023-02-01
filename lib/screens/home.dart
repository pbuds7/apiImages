import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:swipe_deck/swipe_deck.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> users = [];

  List<dynamic> images = [];
  late Future<List> futureList;

  @override
  void initState() {
    super.initState();
    futureList = fetchUsers();
  }

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
              child: FutureBuilder<List>(
                  future: futureList,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return SwipeDeck(
                        startIndex: 3,
                        emptyIndicator: Container(
                          child: const Center(
                            child: Text("Presione el botón"),
                          ),
                        ),
                        cardSpreadInDegrees:
                            5, // Change the Spread of Background Cards
                        onSwipeLeft: () {
                          debugPrint(
                              "USER SWIPED LEFT -> GOING TO NEXT WIDGET");
                        },
                        onSwipeRight: () {
                          debugPrint(
                              "USER SWIPED RIGHT -> GOING TO PREVIOUS WIDGET");
                        },
                        onChange: (index) {
                          debugPrint(images[index]);
                        },
                        widgets: images
                            .map((e) => GestureDetector(
                                  onTap: () {
                                    debugPrint(e);
                                  },
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20.0),
                                      child: Image.network(
                                        '$e',
                                        fit: BoxFit.cover,
                                      )),
                                ))
                            .toList(),
                      );
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }
                    return CircularProgressIndicator();
                  })),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: fetchUsers,
        label: const Text('Mostrar Personajes'),
      ),
    );
  }

  Future<List> fetchUsers() async {
    debugPrint('fetchUsers called');
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
              images.add(imageUrl);
            }
          });
          debugPrint('fetchUsers completed');
          debugPrint(images.length.toString());
          return images;
        default:
          debugPrint('Erorr de proceso');
          throw Exception('Falla en el proceso');
      }
    } catch (e) {
      debugPrint('Error de conexión');
      throw Exception('Falla en la conexión');
    }
  }
}
