import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/UserProvider.dart';
import 'myTextFormField.dart';
import 'RegisterPage.dart';
import 'homePage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // أضفنا GlobalKey للتحقق من صحة الحقول باستخدام MyTextFormField
  final formKey = GlobalKey<FormState>();

  Future<void> login() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final username = usernameController.text.trim();
    final password = passwordController.text;

    final provider = context.read<UserProvider>();
    final success = await provider.login(username, password);

    if (!mounted) return;

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.error ?? 'Login failed'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Colors.indigo,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const SizedBox(height: 50),
                const Icon(
                  Icons.person,
                  size: 100,
                  color: Colors.indigo,
                ),
                const SizedBox(height: 30),

                MyTextFormField(
                  name: 'Username',
                  controller: usernameController,
                ),

                const SizedBox(height: 20),

                MyTextFormField(
                  name: 'Password',
                  obscureText: true,
                  controller: passwordController,
                ),

                const SizedBox(height: 30),

                Consumer<UserProvider>(
                  builder: (context, provider, child) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        backgroundColor: Colors.indigo,
                      ),
                      onPressed: provider.isLoading ? null : login,
                      child: provider.isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                        'Login',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),

                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterPage(),
                      ),
                    );
                  },
                  child: const Text(
                    "Don't have an account? Register",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}