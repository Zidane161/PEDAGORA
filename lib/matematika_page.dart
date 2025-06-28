import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'ulasan_siswa.dart';

class MatematikaGuruPage extends StatefulWidget {
  const MatematikaGuruPage({super.key});

  @override
  State<MatematikaGuruPage> createState() => _MatematikaGuruPageState();
}

class _MatematikaGuruPageState extends State<MatematikaGuruPage> {
  List<dynamic> guruList = [];

  @override
  void initState() {
    super.initState();
    fetchGuruList();
  }

  Future<void> fetchGuruList() async {
    final response = await http.get(
      Uri.parse('http://192.168.50.31/pedagora_api/get_guru_by_pelajaran.php?pelajaran_id=10'),
    );

    if (response.statusCode == 200) {
      setState(() {
        guruList = json.decode(response.body);
      });
    } else {
      print('Gagal mengambil data guru');
    }
  }

  void _showDetailDialog(BuildContext context, dynamic guru) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 32,
                backgroundImage: NetworkImage(
                  'http://192.168.50.31/pedagora_api/uploads/${guru['foto_profil']}',
                ),
              ),
              const SizedBox(height: 8),
              Text(guru['nama_guru'], style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(guru['motto_hidup'] ?? '', textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.school, size: 20),
                  const SizedBox(width: 8),
                  Text(guru['universitas']),
                ],
              ),
              const SizedBox(height: 12),
              ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => UlasanSiswaScreen(guruId: int.parse(guru['guru_id'].toString()))

                    ),
                  );
                },
                child: const Text("Ulasan",style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 8),
              if (guru['file_materi'] != null && guru['file_materi'].toString().isNotEmpty)
                ElevatedButton.icon(style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text("Lihat Materi",style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    Navigator.pop(context);
                    final fileUrl = 'http://192.168.50.31/pedagora_api/uploads/materi/${guru['file_materi']}';
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PDFViewerPage(url: fileUrl),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Matematika'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: guruList.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: guruList.length,
        itemBuilder: (context, index) {
          final guru = guruList[index];
          return GestureDetector(
            onTap: () => _showDetailDialog(context, guru),
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                      'http://192.168.50.31/pedagora_api/uploads/${guru['foto_profil']}',
                    ),
                    radius: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(guru['nama_guru'], style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(guru['motto_hidup'] ?? '', maxLines: 2, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class PDFViewerPage extends StatefulWidget {
  final String url;

  const PDFViewerPage({super.key, required this.url});

  @override
  State<PDFViewerPage> createState() => _PDFViewerPageState();
}

class _PDFViewerPageState extends State<PDFViewerPage> {
  String? localPath;

  @override
  void initState() {
    super.initState();
    _loadPDF();
  }

  Future<void> _loadPDF() async {
    try {
      final response = await http.get(Uri.parse(widget.url));
      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        final dir = await getApplicationDocumentsDirectory();
        final file = File('${dir.path}/materi.pdf');
        await file.writeAsBytes(bytes, flush: true);
        setState(() {
          localPath = file.path;
        });
      } else {
        _showError("Gagal mengunduh file. Status: ${response.statusCode}");
      }
    } catch (e) {
      _showError("Terjadi kesalahan saat mengunduh file: $e");
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Tutup"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Materi PDF"),
      ),
      body: localPath != null
          ? PDFView(
        filePath: localPath!,
        enableSwipe: true,
        swipeHorizontal: true,
        autoSpacing: true,
        pageFling: true,
      )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
