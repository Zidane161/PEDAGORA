import 'package:flutter/material.dart';

class NotifikasiGuru extends StatelessWidget {
  const NotifikasiGuru({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifikasi'),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 1,
        foregroundColor: Colors.black,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: const [
          _NotifikasiTile(
            imagePath: 'assets/arini.png',
            nama: 'Arini',
            pesan: 'Melihat materi anda',
          ),
          _NotifikasiTile(
            imagePath: 'assets/saipul.png',
            nama: 'Saipul',
            pesan: 'Memberi ulasan pada anda',
          ),
        ],
      ),
    );
  }
}

class _NotifikasiTile extends StatelessWidget {
  final String imagePath;
  final String nama;
  final String pesan;

  const _NotifikasiTile({
    required this.imagePath,
    required this.nama,
    required this.pesan,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: CircleAvatar(
          radius: 24,
          backgroundImage: AssetImage(imagePath),
        ),
        title: Text('$nama $pesan'),
      ),
    );
  }
}
