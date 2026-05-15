import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UploadFace extends StatefulWidget {
  const UploadFace({super.key});

  @override
  State<UploadFace> createState() => _UploadFaceState();
}

class _UploadFaceState extends State<UploadFace> {
  final TextEditingController _descriptionController = TextEditingController();

  File? _imageFile;
  bool _uploading = false;

  final _bg = const Color.fromARGB(255, 247, 206, 77);

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (picked == null) return;

    setState(() {
      _imageFile = File(picked.path);
    });
  }

  Future<void> _uploadFace() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please sign in first")),
      );
      return;
    }

    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please choose a face image")),
      );
      return;
    }

    final desc = _descriptionController.text.trim();
    if (desc.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a name/description")),
      );
      return;
    }

    setState(() => _uploading = true);

    try {
      final bytes = await _imageFile!.readAsBytes();

      if (bytes.lengthInBytes > 700 * 1024) {
        setState(() => _uploading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Image too large. Choose smaller image.")),
        );
        return;
      }

      final base64Image = base64Encode(bytes);

      await FirebaseFirestore.instance.collection('photos').add({
        'image': base64Image,
        'description': desc,
        'userId': user.uid,
        'createdAt': Timestamp.now(),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Face uploaded ✅")),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      setState(() => _uploading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Upload failed: $e")),
      );
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: _bg,
        title: const Text(
          "Upload Face",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
        ),
      ),
      body: Container(
        color: _bg,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  height: 220,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: _imageFile == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.face, size: 60, color: Colors.black54),
                            SizedBox(height: 10),
                            Text(
                              "Tap to choose face image",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.file(_imageFile!, fit: BoxFit.cover),
                        ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    hintText: "Enter name / description",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _uploading
                  ? const CircularProgressIndicator(color: Colors.black)
                  : GestureDetector(
                      onTap: _uploadFace,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        height: 55,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Center(
                          child: Text(
                            "Upload",
                            style: TextStyle(
                              color: Color.fromARGB(255, 247, 206, 77),
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
