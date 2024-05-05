import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tugas_api_123210100/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String email = '';
  String password = '';
  String birthDate = '';
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs.getString('email') ?? '';
      password = prefs.getString('password') ?? '';
      birthDate = prefs.getString('birthDate') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.indigo[900],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildProfileItem('Email', email),
            _buildProfileItem('Password', password, isPassword: true),
            _buildProfileItem('Tanggal Lahir', birthDate),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _logout(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(String title, String value, {bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title:',
          style: TextStyle(fontSize: 18.0, color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5.0),
        isPassword
            ? Row(
          children: [
            Expanded(
              child: Text(
                _isPasswordVisible ? value : '******',
                style: TextStyle(fontSize: 18.0, color: Colors.black87),
              ),
            ),
            IconButton(
              icon: Icon(_isPasswordVisible ? Icons.visibility_off : Icons.visibility),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
          ],
        )
            : Text(
          value,
          style: TextStyle(fontSize: 18.0, color: Colors.black87),
        ),
        SizedBox(height: 15.0),
      ],
    );
  }

  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
          (Route<dynamic> route) => false,
    );
  }
}
