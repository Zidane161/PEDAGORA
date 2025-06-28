import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GantiPasswordPage extends StatefulWidget {
  final String userId;
  const GantiPasswordPage({super.key, required this.userId});

  @override
  State<GantiPasswordPage> createState() => _GantiPasswordPageState();
}

class _GantiPasswordPageState extends State<GantiPasswordPage> {
  final TextEditingController lamaController = TextEditingController();
  final TextEditingController baruController = TextEditingController();
  final TextEditingController konfirmasiController = TextEditingController();

  bool isLoading = false;

  Future<void> gantiPassword() async {
    if (baruController.text != konfirmasiController.text) {
      _showMessage("Password baru dan konfirmasi tidak cocok");
      return;
    }

    setState(() => isLoading = true);

    final response = await http.post(
      Uri.parse("http://10.0.2.2/pedagora_api/change_password.php"),
      body: {
        "user_id": widget.userId,
        "old_password": lamaController.text,
        "new_password": baruController.text,
      },
    );

    setState(() => isLoading = false);

    final data = json.decode(response.body);
    _showMessage(data['message']);
  }

  void _showMessage(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Informasi"),
        content: Text(message),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ganti Password")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: lamaController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password Lama"),
            ),
            TextField(
              controller: baruController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password Baru"),
            ),
            TextField(
              controller: konfirmasiController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Konfirmasi Password"),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: isLoading ? null : gantiPassword,
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text("Simpan"),
            )
          ],
        ),
      ),
    );
  }
}
