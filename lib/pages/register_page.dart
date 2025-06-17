import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _message = '';

  Future<void> _register() async {
    try {
      await AuthService().register(
        _emailController.text,
        _passwordController.text,
      );
      setState(() => _message = 'Kayıt başarılı!');
    } catch (e) {
      setState(() => _message = 'Hata: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyanAccent,
      appBar: AppBar(centerTitle:true, backgroundColor: Colors.yellowAccent,title: const Text("Kayıt")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: const Icon(
                Icons.assignment,
                size: 100,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 20,),
            TextField(
              controller: _emailController,
              style: Theme.of(context).textTheme.bodyMedium,
              cursorColor: Colors.teal,
              decoration: InputDecoration(
                labelText: "Email",
                labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.teal,
                  fontWeight: FontWeight.bold,
                ),
                filled: true,
                fillColor: const Color(0xFFEAE6F8),
                contentPadding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                  BorderSide(color: Colors.teal.shade200, width: 1.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                  const BorderSide(color: Colors.teal, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              style: Theme.of(context).textTheme.bodyMedium,
              cursorColor: Colors.teal,
              decoration: InputDecoration(
                labelText: "Şifre",
                labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.teal,
                  fontWeight: FontWeight.bold,
                ),
                filled: true,
                fillColor: const Color(0xFFEAE6F8),
                contentPadding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                  BorderSide(color: Colors.teal.shade200, width: 1.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                  const BorderSide(color: Colors.teal, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(style:ElevatedButton.styleFrom(
              backgroundColor:  Color(0xFFEAE6F8),
            ),onPressed: _register, child: const Text("Kayıt Ol")),
            const SizedBox(height: 10),
            Text(_message),
          ],
        ),
      ),
    );
  }
}
