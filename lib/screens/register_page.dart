import 'package:flutter/material.dart';
import 'package:mobile_final/models/address_model.dart';
import 'package:mobile_final/services/auth.services.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();
  final phoneController = TextEditingController();
  final streetController = TextEditingController();
  final cityController = TextEditingController();
  final zipController = TextEditingController();
  final numberController = TextEditingController();

  final AuthService _authService = AuthService();

  void _register() async {
    if (!_formKey.currentState!.validate()) return;

    final address = AddressModel(
      city: cityController.text.trim(),
      street: streetController.text.trim(),
      number: int.tryParse(numberController.text.trim()) ?? 0,
    );

    final result = await _authService.register(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      username: usernameController.text.trim(),
      phone: phoneController.text.trim(),
      address: address,
    );

    if (result != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Registration successful")));
      Navigator.pop(context); // Go back to login
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Registration failed")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                "Create Account",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: usernameController,
                decoration: const InputDecoration(labelText: "Username"),
                validator: (value) => value!.isEmpty ? "Enter username" : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "Email"),
                validator: (value) => value!.isEmpty ? "Enter email" : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: "Phone"),
                validator: (value) => value!.isEmpty ? "Enter phone" : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Password"),
                validator: (value) =>
                    value!.length < 6 ? "Minimum 6 characters" : null,
              ),
              const SizedBox(height: 24),

              const Text(
                "Address",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              TextFormField(
                controller: streetController,
                decoration: const InputDecoration(labelText: "Street"),
                validator: (value) => value!.isEmpty ? "Enter street" : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: numberController,
                decoration: const InputDecoration(
                  labelText: "House/Unit Number",
                ),
                validator: (value) => value!.isEmpty ? "Enter number" : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: cityController,
                decoration: const InputDecoration(labelText: "City"),
                validator: (value) => value!.isEmpty ? "Enter city" : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: zipController,
                decoration: const InputDecoration(labelText: "Zip Code"),
                validator: (value) => value!.isEmpty ? "Enter ZIP" : null,
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _register,
                child: const Text("Register"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
