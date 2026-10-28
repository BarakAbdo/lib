import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/UserProvider.dart';
import 'myTextFormField.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final namecontroller = TextEditingController();
  final emailcontroller = TextEditingController();
  final usernamecontroller = TextEditingController();
  final passwordcontroller = TextEditingController();

  final formKey = GlobalKey<FormState>();

  void register() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final userProvider = context.read<UserProvider>();
    final success = await userProvider.register(
      namecontroller.text.trim(),
      emailcontroller.text.trim(),
      usernamecontroller.text.trim(),
      passwordcontroller.text,
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration Successful'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(userProvider.error ?? 'Registration failed'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    namecontroller.dispose();
    emailcontroller.dispose();
    usernamecontroller.dispose();
    passwordcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<UserProvider>().isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Signup Screen'),
        backgroundColor: Colors.indigo,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const SizedBox(height: 30),
                const Icon(
                  Icons.person_add,
                  size: 100,
                  color: Colors.indigo,
                ),
                const SizedBox(height: 30),

                MyTextFormField(
                  name: 'Full Name',
                  controller: namecontroller,
                ),
                const SizedBox(height: 20),

                MyTextFormField(
                  name: 'Email',
                  controller: emailcontroller,
                ),
                const SizedBox(height: 20),

                MyTextFormField(
                  name: 'Username',
                  controller: usernamecontroller,
                ),
                const SizedBox(height: 20),

                MyTextFormField(
                  name: 'Password',
                  obscureText: true,
                  controller: passwordcontroller,
                ),
                const SizedBox(height: 30),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    backgroundColor: Colors.indigo,
                  ),
                  onPressed: isLoading ? null : register,
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                    'Register',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                const SizedBox(height: 20),

                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Already have an account? Login',
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