import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadMapBase64 extends StatefulWidget {
  const UploadMapBase64({super.key});

  @override
  State<UploadMapBase64> createState() => _UploadMapBase64State();
}

class _UploadMapBase64State extends State<UploadMapBase64> {
  File? _imageFile;
  bool _uploading = false;

  final TextEditingController _mapNameController = TextEditingController();

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

  Future<void> _uploadMap() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please sign in first")),
      );
      return;
    }

    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please choose a map image")),
      );
      return;
    }

    final mapName = _mapNameController.text.trim();
    if (mapName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter map name")),
      );
      return;
    }

    setState(() => _uploading = true);

    try {
      final bytes = await _imageFile!.readAsBytes();

      if (bytes.lengthInBytes > 700 * 1024) {
        if (!mounted) return;
        setState(() => _uploading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Image too large. Choose smaller image.")),
        );
        return;
      }

      final base64Image = base64Encode(bytes);

      await FirebaseFirestore.instance.collection("maps").add({
        "ownerId": user.uid,
        "mapName": mapName,
        "imageBase64": base64Image,
        "createdAt": Timestamp.now(),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Map uploaded ✅")),
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
    _mapNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    final isTablet = w >= 700;
    final bg = const Color.fromARGB(255, 247, 206, 77);

    final pad = (w * 0.06).clamp(14.0, 40.0);

    final appBarTitleSize = (isTablet ? w * 0.03 : w * 0.055).clamp(18.0, 26.0);

    final hintSize = (isTablet ? w * 0.02 : w * 0.045).clamp(14.0, 18.0);
    final iconSize = (isTablet ? w * 0.07 : w * 0.14).clamp(45.0, 75.0);

    final imageBoxH = (h * 0.30).clamp(180.0, 320.0);
    final btnH = (h * 0.07).clamp(48.0, 58.0);
    final btnFont = (isTablet ? w * 0.02 : w * 0.05).clamp(16.0, 22.0);

    final radiusBox = 20.0;
    final radiusBtn = 30.0;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: bg,
        title: Text(
          "Upload Map",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: appBarTitleSize,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          color: bg,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(pad),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: (h * 0.01).clamp(8.0, 14.0)),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: imageBoxH,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(radiusBox),
                    ),
                    child: _imageFile == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.image,
                                  size: iconSize, color: Colors.black54),
                              SizedBox(height: (h * 0.012).clamp(8.0, 14.0)),
                              Text(
                                "Tap to choose map image",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: hintSize,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(radiusBox),
                            child: Image.file(
                              _imageFile!,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                ),
                SizedBox(height: (h * 0.025).clamp(14.0, 22.0)),
                TextField(
                  controller: _mapNameController,
                  decoration: InputDecoration(
                    hintText: "Enter map name",
                    hintStyle: TextStyle(fontSize: hintSize),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(radiusBox),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: (w * 0.05).clamp(14.0, 22.0),
                      vertical: (h * 0.02).clamp(12.0, 18.0),
                    ),
                  ),
                ),
                SizedBox(height: (h * 0.025).clamp(14.0, 22.0)),
                if (_uploading)
                  const Center(
                    child: CircularProgressIndicator(color: Colors.black),
                  )
                else
                  GestureDetector(
                    onTap: _uploadMap,
                    child: Container(
                      height: btnH,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(radiusBtn),
                      ),
                      child: Center(
                        child: Text(
                          "Upload",
                          style: TextStyle(
                            color: bg,
                            fontSize: btnFont,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                SizedBox(height: (h * 0.03).clamp(18.0, 30.0)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
