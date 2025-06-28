import 'package:flutter/material.dart';
import 'package:project/notifikasi_guru.dart';
import 'package:project/setting_guru.dart';
import 'package:project/ulasan_guru.dart';
import 'profile_guru.dart';
import 'upload_materi.dart';

class DashboardGuru extends StatelessWidget {
  final String namaUser;
  final String emailUser;
  final String fotoProfil;
  final int guruId;

  const DashboardGuru({
    Key? key,
    required this.namaUser,
    required this.emailUser,
    required this.fotoProfil,
    required this.guruId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Logo PEDAGORA
            Center(
              child: Image.asset(
                'assets/logo_pedagora.png',
                height: 200,
              ),
            ),

            const SizedBox(height: 20),

            // Foto Profil dari server
            CircleAvatar(
              radius: 45,
              backgroundImage: NetworkImage(
                'http://10.0.2.2/pedagora_api/uploads/$fotoProfil',
              ),
            ),

            const SizedBox(height: 12),

            Text(
              namaUser,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            Text(
              emailUser,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),

            const SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Wrap(
                spacing: 20,
                runSpacing: 20,
                alignment: WrapAlignment.center,
                children: [
                  menuItem(context, Icons.person, 'Profil'),
                  menuItem(context, Icons.folder, 'Post Resume'),
                  menuItem(context, Icons.notifications, 'Notifikasi'),
                  menuItem(context, Icons.star, 'Ulasan'),
                  menuItem(context, Icons.settings, 'Setelan'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  Widget menuItem(BuildContext context, IconData icon, String label) {
    return GestureDetector(
      onTap: () {
        if (label == 'Profil') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfileGuru(
                emailUser: emailUser,
                fotoProfil: fotoProfil,
              ),
            ),
          );
        } else if (label == 'Post Resume') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UploadMateriScreen(userId: guruId),
            ),
          );
        } else if (label == 'Setelan') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SettingsGuru()),
          );
        } else if (label == 'Ulasan') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UlasanGuruScreen(guruId: guruId),
            ),
          );
        } else if (label == 'Notifikasi') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NotifikasiGuru()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Fitur "$label" belum tersedia')),
          );
        }
      },
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade600, Colors.blue.shade900],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.shade200,
              offset: const Offset(4, 4),
              blurRadius: 8,
              spreadRadius: 1,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: const Offset(-2, -2),
              blurRadius: 6,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: Colors.white),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
