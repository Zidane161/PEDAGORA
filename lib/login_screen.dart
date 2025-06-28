import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project/dashboard_screen.dart';
import 'package:project/dashboard_guru.dart';
import 'package:project/role_selection_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> loginUser() async {
    final response = await http.post(
      Uri.parse("http://10.0.2.2/pedagora_api/login.php"),
      body: {
        "email": emailController.text,
        "password": passwordController.text,
      },
    );

    final data = jsonDecode(response.body);

    if (data['success']) {
      String namaUser = data['user']['nama'] ?? '';
      String emailUser = data['user']['email'] ?? '';
      String role = data['user']['role'] ?? '';
      String fotoProfil = data['user']['foto_profil'] ?? '';
      int userId = int.parse(data['user']['id'].toString());

      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('user_id', userId);
      await prefs.setString('nama', namaUser);
      await prefs.setString('email', emailUser);
      await prefs.setString('role', role);
      await prefs.setString('foto_profil', fotoProfil);

      if (role == 'guru') {
        final guruResponse = await http.get(
          Uri.parse('http://10.0.2.2/pedagora_api/get_guru_id.php?user_id=$userId'),
        );
        final guruData = json.decode(guruResponse.body);
        if (guruData['guru_id'] != null) {
          int guruId = int.parse(guruData['guru_id'].toString());
          await prefs.setInt('guru_id', guruId);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => DashboardGuru(
                namaUser: namaUser,
                emailUser: emailUser,
                fotoProfil: fotoProfil,
                guruId: guruId,
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Akun guru tidak ditemukan")),
          );
        }
      } else if (role == 'siswa') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DashboardScreen(
              namaUser: namaUser,
              emailUser: emailUser,
              fotoProfil: fotoProfil,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Role tidak dikenali")),
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login berhasil")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal: ${data['message']}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo_pedagora.png', height: 200),
            const SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: loginUser,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Masuk',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 10),
            const Text('atau daftar dengan'),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.g_mobiledata, size: 32),
                SizedBox(width: 20),
                Icon(Icons.facebook, size: 28),
              ],
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RoleSelectionScreen()),
                );
              },
              child: const Text(
                'Belum punya akun? Daftar',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
