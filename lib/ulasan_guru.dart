import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UlasanGuruScreen extends StatefulWidget {
  final int guruId;
  const UlasanGuruScreen({Key? key, required this.guruId}) : super(key: key);

  @override
  State<UlasanGuruScreen> createState() => _UlasanGuruScreenState();
}

class _UlasanGuruScreenState extends State<UlasanGuruScreen> {
  List<dynamic> ulasanList = [];
  bool isLoading = true;
  double avgRating = 0.0;

  @override
  void initState() {
    super.initState();
    fetchUlasan();
  }

  Future<void> fetchUlasan() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2/pedagora_api/get_ulasan.php?guru_id=${widget.guruId}'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      setState(() {
        ulasanList = data['ulasan'];
        avgRating = double.tryParse(data['average_rating'].toString()) ?? 0.0;
        isLoading = false;
      });
    } else {
      print("Gagal ambil data ulasan");
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget ratingBar(double rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        return Icon(
          i < rating ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 16,
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Penilaian Keseluruhan")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ulasanList.isEmpty
          ? const Center(child: Text("Belum ada ulasan."))
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              avgRating.toStringAsFixed(1),
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            ratingBar(avgRating),
            const SizedBox(height: 8),
            Text("Dari ${ulasanList.length} Ulasan"),
            const Divider(height: 32),
            Expanded(
              child: ListView.builder(
                itemCount: ulasanList.length,
                itemBuilder: (context, index) {
                  final ulasan = ulasanList[index];
                  final namaUser = ulasan['nama_user'] ?? 'Pengguna';
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: ulasan['foto_profil'] != null && ulasan['foto_profil'].toString().isNotEmpty
                          ? NetworkImage('http://10.0.2.2/pedagora_api/uploads/${ulasan['foto_profil']}')
                          : const AssetImage('assets/profile_sample.png') as ImageProvider,
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(namaUser, style: const TextStyle(fontWeight: FontWeight.bold)),
                        ratingBar(double.tryParse(ulasan['rating'].toString()) ?? 0.0),
                      ],
                    ),
                    subtitle: Text(ulasan['komentar'] ?? ''),
                    trailing: Text(
                      ulasan['created_at'].toString().split(' ')[0],
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
