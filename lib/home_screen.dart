import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tugas_api_123210100/detail_screen.dart';
import 'package:tugas_api_123210100/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<dynamic>> _ships;

  @override
  void initState() {
    super.initState();
    _ships = _fetchShips();
  }

  Future<List<dynamic>> _fetchShips() async {
    final response = await http.get(Uri.parse('https://api.spacexdata.com/v4/ships'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData is List) {
        return jsonData;
      } else {
        throw Exception('Invalid data format: expected List');
      }
    } else {
      throw Exception('Failed to load ships');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: const Row(
          children: [
            Icon(Icons.directions_boat, color: Colors.white),
            SizedBox(width: 8),
            Text('SpaceX Ships', style: TextStyle(fontSize: 20, color: Colors.white)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.blue[900],
        child: FutureBuilder<List<dynamic>>(
          future: _ships,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(color: Colors.blue[400]));
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.white)));
            } else {
              final ships = snapshot.data!;
              return ListView.builder(
                itemCount: ships.length,
                itemBuilder: (context, index) {
                  final ship = ships[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: ListTile(
                      title: Text(ship['name'], style: const TextStyle(color: Colors.white)),
                      subtitle: Text(ship['type'] ?? 'Type not specified', style: const TextStyle(color: Colors.white70)),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailScreen(ship: ship),
                          ),
                        );
                      },
                      tileColor: Colors.blue[800],
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
