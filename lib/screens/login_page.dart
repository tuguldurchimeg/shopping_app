import 'package:flutter/material.dart';
import 'package:mobile_final/provider/global_provider.dart';
import 'package:mobile_final/screens/register_page.dart';
import 'package:mobile_final/services/auth.services.dart';
import 'package:mobile_final/screens/home_page.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  final void Function(Locale)? onLocaleChange;

  const LoginScreen({super.key, this.onLocaleChange});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController(text: "tgld@gmail.com");
    passwordController = TextEditingController(text: "test@123");
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final auth = AuthService();

      final firebaseUser = await auth.signIn(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (firebaseUser != null) {
        final profile = await auth.fetchUserProfile(firebaseUser.uid);
        if (profile != null) {
          final provider = Provider.of<Global_provider>(context, listen: false);
          provider.setCurrentUser(profile);

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Login successful')));

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => HomePage()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No user profile found')),
          );
        }
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Login failed')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Нэвтрэх'),
        actions: [
          PopupMenuButton<Locale>(
            icon: const Icon(Icons.language),
            onSelected: (locale) {
              widget.onLocaleChange?.call(locale);
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: Locale('en'), child: Text("English")),
              PopupMenuItem(value: Locale('mn'), child: Text("Монгол")),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 30),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Имэйл'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'abc@gmail.com',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Имэйл-ээ оруулна уу!';
                    } else if (!RegExp(
                      r'^[^@]+@[^@]+\.[^@]+',
                    ).hasMatch(value)) {
                      return 'Буруу имэйл байна.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                const Text('Нууц үг'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: '••••••••',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Нууц үгээ оруулна уу';
                    } else if (value.length < 6) {
                      return 'Дор хаяж 6 тэмдэгт байх ёстой';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      'Нэвтрэх',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RegisterScreen(),
                        ),
                      );
                    },
                    child: const Text("Бүртгүүлэх"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
