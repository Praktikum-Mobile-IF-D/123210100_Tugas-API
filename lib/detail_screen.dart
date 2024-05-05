import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailScreen extends StatelessWidget {
  final Map<String, dynamic> ship;

  DetailScreen({required this.ship});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ship Details',
          style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue[900],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.blue[800],
                borderRadius: BorderRadius.circular(12.0),
                image: DecorationImage(
                  image: NetworkImage(ship['image'] ?? ''),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              ship['name'] ?? 'Name not available',
              style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Type: ${ship['type'] ?? 'Not specified'}',
              style: const TextStyle(fontSize: 16.0, color: Colors.black54),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Active: ${ship['active'] ? 'Yes' : 'No'}',
              style: TextStyle(fontSize: 16.0, color: ship['active'] ? Colors.green : Colors.red),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Year Built: ${ship['year_built'] ?? 'Not specified'}',
              style: const TextStyle(fontSize: 16.0, color: Colors.black54),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Home Port: ${ship['home_port'] ?? 'Not specified'}',
              style: const TextStyle(fontSize: 16.0, color: Colors.black54),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                String url = ship['link'];
                await launchURL(url);
              },
              child: const Text(
                'View More Info',
                style: TextStyle(fontSize: 16.0),
              ),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.blue[900],
                padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> launchURL(String url) async {
    final Uri _url = Uri.parse(url);
    if (!await launchUrl(_url)) {
      throw "Couldn't launch url";
    }
  }
}
