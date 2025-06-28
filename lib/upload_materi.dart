import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'dart:convert';

class UploadMateriScreen extends StatefulWidget {
  final int userId;
  const UploadMateriScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<UploadMateriScreen> createState() => _UploadMateriScreenState();
}

class _UploadMateriScreenState extends State<UploadMateriScreen> {
  final TextEditingController universitasController = TextEditingController();
  final TextEditingController tentangController = TextEditingController();
  String? selectedPelajaran;
  PlatformFile? selectedFile;

  bool dataAda = false;

  final List<Map<String, dynamic>> pelajaranList = [
    {"id": 10, "nama": "Matematika"},
    {"id": 11, "nama": "Fisika"},
    {"id": 12, "nama": "Kimia"},
    {"id": 13, "nama": "Biologi"},
    {"id": 14, "nama": "Sejarah"},
    {"id": 15, "nama": "Bahasa"},
    {"id": 16, "nama": "SNBT"},
  ];

  @override
  void initState() {
    super.initState();
    fetchExistingData();
  }

  Future<void> fetchExistingData() async {
    try {
      final response = await http.get(Uri.parse(
          "http://10.0.2.2/pedagora_api/get_guru_by_user.php?user_id=${widget.userId}"));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null && data.isNotEmpty) {
          setState(() {
            dataAda = true;
            universitasController.text = data['universitas'] ?? '';
            tentangController.text = data['motto_hidup'] ?? '';
            selectedPelajaran = data['bidang_pelajaran']?.toString();
          });
        }
      }
    } catch (e) {
      print("Gagal mengambil data guru: $e");
    }
  }

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null) {
      setState(() {
        selectedFile = result.files.first;
      });
    }
  }

  void uploadData() async {
    if (selectedPelajaran == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pilih bidang pelajaran!")),
      );
      return;
    }

    final uri = Uri.parse("http://10.0.2.2/pedagora_api/upload_materi.php");

    var request = http.MultipartRequest('POST', uri);
    request.fields['user_id'] = widget.userId.toString();
    request.fields['universitas'] = universitasController.text;
    request.fields['bidang_pelajaran'] = selectedPelajaran!;
    request.fields['motto_hidup'] = tentangController.text;
    request.fields['update'] = dataAda ? "1" : "0"; // Optional flag

    if (selectedFile != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'file_materi',
        selectedFile!.path!,
        filename: path.basename(selectedFile!.path!),
      ));
    }

    final response = await request.send();

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(dataAda ? "Data berhasil diperbarui!" : "Berhasil disimpan!")),
      );
      setState(() {
        selectedFile = null;
        dataAda = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal unggah. Code: ${response.statusCode}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Unggah Materi')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const Text(
              'Unggah Materi Anda!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: pickFile,
              child: Container(
                width: double.infinity,
                height: 120,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: selectedFile == null
                      ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.cloud_upload, size: 40, color: Colors.grey),
                      SizedBox(height: 8),
                      Text('Klik untuk mengunggah PDF'),
                    ],
                  )
                      : Text(selectedFile!.name),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: universitasController,
              decoration: const InputDecoration(labelText: 'Asal Universitas'),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Bidang Pelajaran'),
              value: selectedPelajaran,
              items: pelajaranList
                  .map((e) => DropdownMenuItem(
                value: e["id"].toString(),
                child: Text(e["nama"]),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedPelajaran = value;
                });
              },
            ),
            const SizedBox(height: 20),
            TextField(
              controller: tentangController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Tentang Anda'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: uploadData,
              child: Text(dataAda ? 'Perbarui Data' : 'Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
