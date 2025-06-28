import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UlasanSiswaScreen extends StatefulWidget {
  final int guruId;

  const UlasanSiswaScreen({Key? key, required this.guruId}) : super(key: key);

  @override
  State<UlasanSiswaScreen> createState() => _UlasanSiswaScreenState();
}

class _UlasanSiswaScreenState extends State<UlasanSiswaScreen> {
  int selectedRating = 0;
  final TextEditingController komentarController = TextEditingController();
  int? siswaId;

  @override
  void initState() {
    super.initState();
    loadSiswaId();
  }

  Future<void> loadSiswaId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      siswaId = prefs.getInt('user_id');
    });
  }

  void submitUlasan() async {
    if (siswaId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("ID siswa tidak ditemukan.")),
      );
      return;
    }

    if (selectedRating == 0 || komentarController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Isi rating dan komentar terlebih dahulu.")),
      );
      return;
    }

    final url = Uri.parse('http://10.0.2.2/pedagora_api/submit_ulasan.php');
    final response = await http.post(url, body: {
      'siswa_id': siswaId.toString(),
      'guru_id': widget.guruId.toString(),
      'rating': selectedRating.toString(),
      'komentar': komentarController.text,
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'])),
      );
      komentarController.clear();
      setState(() {
        selectedRating = 0;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Terjadi kesalahan saat mengirim ulasan.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ulasan")),
      body: siswaId == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text("Beri Rating", style: TextStyle(fontSize: 18)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < selectedRating ? Icons.star : Icons.star_border,
                    color: Colors.blueAccent,
                  ),
                  onPressed: () {
                    setState(() {
                      selectedRating = index + 1;
                    });
                  },
                );
              }),
            ),
            TextField(
              controller: komentarController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Komentar",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: submitUlasan,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Kirim',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
