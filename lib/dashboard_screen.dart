import 'package:flutter/material.dart';
import 'package:project/kimia_page.dart';
import 'notifikasi_screen.dart';
import 'page_others.dart';
import 'matematika_page.dart';
import 'fisika_page.dart';
import 'profile_screen.dart';
import 'setting_screen.dart';
import 'kimia_page.dart';

class DashboardScreen extends StatefulWidget {
  final String namaUser;
  final String emailUser;
  final String fotoProfil;

  const DashboardScreen({super.key, required this.namaUser, required this.emailUser, required this.fotoProfil});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.9);
    Future.delayed(const Duration(seconds: 3), _autoScroll);
  }

  void _autoScroll() {
    if (!mounted) return;
    setState(() {
      _currentPage++;
      if (_currentPage > 2) _currentPage = 0;
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
    Future.delayed(const Duration(seconds: 3), _autoScroll);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFB3E5FC), // biru muda
              Colors.white,       // putih
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications, size: 28),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const NotifikasiScreen()),
                      );
                    },
                  ),
                  Image.asset('assets/logo_pedagora.png', height: 80),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileScreen(
                            emailUser: widget.emailUser,
                            fotoProfil: widget.fotoProfil,
                          ),
                        ),
                      );
                    },
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(
                        'http://10.0.2.2/pedagora_api/uploads/${widget.fotoProfil}',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text("Hi, ${widget.namaUser}!", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.grey[200],
                        ),
                        child: const TextField(
                          decoration: InputDecoration(
                            hintText: 'Cari gurumu di sini...',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SettingsScreen()),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(10),
                        child: const Icon(Icons.settings),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text("Top Guru Bulan Ini", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                SizedBox(
                  height: 180,
                  child: PageView(
                    controller: _pageController,
                    children: const [
                      _TopGuruCard(imagePath: 'assets/top_guru1.png'),
                      _TopGuruCard(imagePath: 'assets/top_guru2.png'),
                      _TopGuruCard(imagePath: 'assets/top_guru3.png'),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  children: [
                    _CategoryTile(icon: Icons.add, label: 'Matematika', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MatematikaGuruPage()))),
                    _CategoryTile(icon: Icons.science, label: 'Fisika', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const FisikaGuruPage()))),
                    _CategoryTile(icon: Icons.bubble_chart, label: 'Kimia', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const KimiaGuruPage()))),
                    const _CategoryTile(icon: Icons.book, label: 'Sejarah'),
                    const _CategoryTile(icon: Icons.menu_book, label: 'Bahasa'),
                    _CategoryTile(icon: Icons.more_horiz, label: 'Lainnya', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PageOthers()))),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _CategoryTile({required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 4,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: const Offset(2, 4),
                blurRadius: 6,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 36, color: Colors.white),
              const SizedBox(height: 8),
              Text(label, style: const TextStyle(color: Colors.white, fontSize: 14), textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopGuruCard extends StatelessWidget {
  final String imagePath;

  const _TopGuruCard({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(imagePath, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
