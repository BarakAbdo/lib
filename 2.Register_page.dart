import 'package:flutter/material.dart';
import '0.myTextFormField.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Register - Hospital System'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text('إنشاء حساب جديد', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  const MyTextFormField(name: "Full Name"),
                  const SizedBox(height: 15),
                  const MyTextFormField(name: "Email"),
                  const SizedBox(height: 15),
                  const MyTextFormField(name: "Password", obscureText: true),
                  const SizedBox(height: 25),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      backgroundColor: Colors.green,
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('تسجيل الحساب', style: TextStyle(color: Colors.white, fontSize: 18)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}