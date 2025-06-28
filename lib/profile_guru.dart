import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'dart:convert';

class ProfileGuru extends StatefulWidget {
  final String emailUser;
  final String fotoProfil;

  const ProfileGuru({super.key, required this.emailUser, required this.fotoProfil});

  @override
  State<ProfileGuru> createState() => _ProfileGuruState();
}

class _ProfileGuruState extends State<ProfileGuru> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController telpController = TextEditingController();
  final TextEditingController ttlController = TextEditingController();
  final TextEditingController asalSekolahController = TextEditingController();

  File? _imageFile;
  String currentFotoProfil = '';

  @override
  void initState() {
    super.initState();
    emailController.text = widget.emailUser;
    currentFotoProfil = widget.fotoProfil;
    getProfile(); // Ambil data dari API
  }

  Future<void> getProfile() async {
    var uri = Uri.parse("http://10.0.2.2/pedagora_api/get_profile.php?email=${widget.emailUser}");
    var response = await http.get(uri);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        namaController.text = data['nama'] ?? '';
        alamatController.text = data['alamat'] ?? '';
        telpController.text = data['no_telepon'] ?? '';
        ttlController.text = data['tempat_tanggal_lahir'] ?? '';
        asalSekolahController.text = data['asal_sekolah'] ?? '';
        currentFotoProfil = data['foto_profil'] ?? currentFotoProfil;
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
      });
    }
  }

  Future<void> simpanProfile() async {
    var uri = Uri.parse("http://10.0.2.2/pedagora_api/profile.php");
    var request = http.MultipartRequest("POST", uri);

    request.fields['nama'] = namaController.text;
    request.fields['email'] = emailController.text;
    request.fields['alamat'] = alamatController.text;
    request.fields['no_telepon'] = telpController.text;
    request.fields['tempat_tanggal_lahir'] = ttlController.text;
    request.fields['asal_sekolah'] = asalSekolahController.text;

    if (_imageFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'foto_profil',
          _imageFile!.path,
          filename: p.basename(_imageFile!.path),
        ),
      );
    }

    var response = await request.send();
    var responseData = await response.stream.bytesToString();
    final data = jsonDecode(responseData);

    if (!mounted) return;

    if (response.statusCode == 200) {
      setState(() {
        // Jika API mengembalikan foto baru
        if (data['foto_profil'] != null) {
          currentFotoProfil = data['foto_profil'];
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message']), backgroundColor: Colors.green),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal menyimpan"), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: _imageFile != null
                          ? FileImage(_imageFile!)
                          : NetworkImage('http://10.0.2.2/pedagora_api/uploads/$currentFotoProfil')
                      as ImageProvider,
                    ),
                    TextButton(
                      onPressed: _pickImage,
                      child: const Text("Ganti Foto", style: TextStyle(color: Colors.blue)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              buildTextField(namaController, 'Nama'),
              buildTextField(emailController, 'Email', readOnly: true),
              buildTextField(alamatController, 'Alamat'),
              buildTextField(telpController, 'No Telepon'),
              buildTextField(ttlController, 'Tempat Tanggal Lahir'),
              buildTextField(asalSekolahController, 'Asal Sekolah'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: simpanProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  minimumSize: const Size(double.infinity, 45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text("Simpan", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, String label, {bool readOnly = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        decoration: InputDecoration(
          hintText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
