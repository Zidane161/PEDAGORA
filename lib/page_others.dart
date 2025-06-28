import 'package:flutter/material.dart';

class PageOthers extends StatelessWidget {
  const PageOthers({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> subjects = [
      {'icon': Icons.science, 'label': 'Fisika'},
      {'icon': Icons.bubble_chart, 'label': 'Kimia'},
      {'icon': Icons.book, 'label': 'Sejarah'},
      {'icon': Icons.menu_book, 'label': 'Bahasa'},
      {'icon': Icons.brightness_medium, 'label': 'Agama'},
      {'icon': Icons.gavel, 'label': 'PPKN'},
      {'icon': Icons.add, 'label': 'Matematika'},
      {'iconPath': 'assets/icon_snbt.png', 'label': 'SNBT'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.separated(
          itemCount: subjects.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final subject = subjects[index];

            Widget iconWidget;
            if (subject.containsKey('icon')) {
              iconWidget = Icon(subject['icon'], size: 32, color: Colors.white);
            } else {
              iconWidget = Image.asset(subject['iconPath'], width: 32, height: 32);
            }

            return Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[800],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: iconWidget,
                ),
                const SizedBox(width: 16),
                Text(
                  subject['label'],
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
