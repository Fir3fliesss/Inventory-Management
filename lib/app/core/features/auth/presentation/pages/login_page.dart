import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/auth_controller.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController controller = Get.put(AuthController());
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            Obx(() => controller.isLoading.value
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () {
                      // Validasi input sebelum login
                      if (emailController.text.isEmpty || passwordController.text.isEmpty) {
                        Get.snackbar('Error', 'Email dan password harus diisi');
                        return;
                      }
                      controller.login(
                        emailController.text,
                        passwordController.text,
                      );
                    },
                    child: const Text('Login'),
                  )),
            TextButton(
              onPressed: () => Get.toNamed('/signup'),
              child: const Text('Belum punya akun? Daftar'),
            ),
          ],
        ),
      ),
    );
  }
}
