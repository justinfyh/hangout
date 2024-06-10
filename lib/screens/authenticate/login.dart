import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hangout/screens/authenticate/register.dart';
import '../../services/auth.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  // final void Function() toggleView;

  // const Login({super.key, required this.toggleView});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      String username = _usernameController.text;
      String password = _passwordController.text;
      User? user = await _auth.signInEmailPassword(username, password);
      if (user?.email != null) {
        Navigator.pop(context);
      }
    }
  }

  void _handleGoogleSignIn() async {
    try {
      await _auth.signInWithGoogle();
    } catch (e) {}
  }

  // final StorageService _storage = StorageService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: Text('Login'),
              ),
              // IconButton(
              //     onPressed: () {},
              //     icon: Image.asset('assets/icons/google.png')),
              // ElevatedButton(
              //     onPressed: _handleGoogleSignIn, child: Text('Google')),
              ElevatedButton.icon(
                onPressed: _handleGoogleSignIn,
                icon: Image.asset('assets/icons/google.png'),
                label: Text('Continue with Google'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
