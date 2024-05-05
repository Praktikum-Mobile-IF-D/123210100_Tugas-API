import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tugas_api_123210100/login_screen.dart';
import 'package:intl/intl.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();
  DateTime? _selectedDate;
  bool isPasswordVisible = false;

  Future<void> _saveUserData(String email, String password, String birthDate) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await prefs.setString('password', password);
    await prefs.setString('birthDate', birthDate);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        birthDateController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
      });
    }
  }

  void _goToLogin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  bool _validateEmail(String email) {
    String pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(email);
  }

  bool _validatePassword(String password) {
    return password.length >= 8;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Register',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.indigo[900],
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                filled: true,
                fillColor: Colors.blueGrey[100],
              ),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                filled: true,
                fillColor: Colors.blueGrey[100],
                suffixIcon: IconButton(
                  icon: Icon(
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                ),
              ),
              obscureText: !isPasswordVisible,
            ),
            SizedBox(height: 10.0),
            TextFormField(
              controller: birthDateController,
              decoration: InputDecoration(
                labelText: 'Tanggal Lahir',
                filled: true,
                fillColor: Colors.blueGrey[100],
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                ),
              ),
              readOnly: true,
              onTap: () => _selectDate(context),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                String email = emailController.text;
                String password = passwordController.text;
                String birthDate = birthDateController.text;

                if (!_validateEmail(email)) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text('Email tidak valid.'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                } else if (!_validatePassword(password)) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text('Password harus memiliki panjang minimal 6 karakter.'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                } else if (email.isEmpty || password.isEmpty || birthDate.isEmpty) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text('Semua formulir harus diisi.'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  _saveUserData(email, password, birthDate);
                  _goToLogin(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo[900],
              ),
              child: const Text(
                'Register',
                style: TextStyle(color: Colors.white),
              ),
            ),

            SizedBox(height: 10.0),
            TextButton(
              onPressed: () {
                _goToLogin(context);
              },
              child: Text(
                'Sudah punya akun? Login disini',
                style: TextStyle(color: Colors.indigo[900]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
