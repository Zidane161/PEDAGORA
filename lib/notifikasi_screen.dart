import 'package:flutter/material.dart';

class NotifikasiScreen extends StatelessWidget {
  const NotifikasiScreen({super.key});

  final List<Map<String, String>> notifikasi = const [
    {
      'icon': 'assets/icon_search.png',
      'text': 'Pak Dono sedang melihat permintaan anda!',
    },
    {
      'icon': 'assets/icon_clock.png',
      'text': 'Waktu Terus Berjalan, UTBK dikit lagi nih! ⏳. Ayo Mulai belajar sekarang!',
    },
    {
      'icon': 'assets/icon_search.png',
      'text': 'Bu Mia sedang melihat permintaan anda!',
    },
    {
      'icon': 'assets/icon_books.png',
      'text': 'Butuh Bantuan Belajar? Guru Terbaik Menunggu di Sini!',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Notifikasi'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: notifikasi.length,
        itemBuilder: (context, index) {
          final notif = notifikasi[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              leading: Image.asset(
                notif['icon']!,
                width: 30,
                height: 30,
              ),
              title: Text(
                notif['text']!,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          );
        },
      ),
    );
  }
}
