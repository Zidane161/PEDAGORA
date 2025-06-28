import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project/login_screen.dart'; // Ganti dengan path file login kamu

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  // Fungsi untuk logout
  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Hapus semua data yang tersimpan
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setelan'),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 1,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Akun Terhubung
            const Text(
              "Akun Terhubung",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Image.asset('assets/akun.png', width: 64, height: 64),
              ],
            ),
            const SizedBox(height: 24),

            // Bahasa
            ListTile(
              title: const Text("Bahasa"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text("Indonesia", style: TextStyle(color: Colors.grey)),
                  SizedBox(width: 4),
                  Icon(Icons.chevron_right),
                ],
              ),
              onTap: () {
                // navigasi ke halaman ubah bahasa jika ada
              },
            ),

            // FAQ
            const ListTile(
              title: Text("FAQ"),
              trailing: Icon(Icons.chevron_right),
            ),

            // Ganti Password
            ListTile(
              title: const Text("Ganti Password"),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // navigasi ke halaman ubah password jika ada
              },
            ),

            const Spacer(),

            // Tombol Keluar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  logout(context); // Panggil fungsi logout
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[700],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text(
                  'Keluar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Tombol Hapus Akun
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // hapus akun logic
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[800],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text(
                  'Hapus Akun',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
