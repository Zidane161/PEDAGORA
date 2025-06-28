import 'package:flutter/material.dart';
import 'start_screen.dart'; // Halaman setelah tutorial

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key});

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> tutorialData = [
    {
      "image": "assets/tutorial3.png", // Ganti dengan gambar kamu
      "title": "Temukan Guru Sesuai\nKebutuhan Anda!",
      "desc": "Cari guru les privat dan atau guru pengganti sekolah anda\nsesuai kebutuhan"
    },
    {
      "image": "assets/tutorial2.png",
      "title": "Cari dan Temukan Guru!",
      "desc": "Cari guru les privat atau guru pengganti sekolah anda\ndengan mudah dan cepat!"
    },
    {
    "image": "assets/tutorial1.png",
    "title": "Dapatkan Guru Sesuai Kriteria!",
    "desc": "Berikan dan lihat ulasan terkait guru yang anda cari!"
    },
  ];

  void _nextPage() {
    if (_currentPage == tutorialData.length - 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const StartScreen()),
      );
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }


  Widget buildPage(String image, String title, String desc) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image, height: 250),
          const SizedBox(height: 40),
          Text(title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Text(desc,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.grey)),
          const SizedBox(height: 30),
          buildIndicator(),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: _nextPage,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
            ),
            child: const Text("Next", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget buildIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(tutorialData.length, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: _currentPage == index ? 12 : 8,
          height: _currentPage == index ? 12 : 8,
          decoration: BoxDecoration(
            color: _currentPage == index ? Colors.blue : Colors.grey,
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        itemCount: tutorialData.length,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        itemBuilder: (context, index) {
          return buildPage(
            tutorialData[index]['image']!,
            tutorialData[index]['title']!,
            tutorialData[index]['desc']!,
          );
        },
      ),
    );
  }
}
