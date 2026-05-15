import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DisplayImages extends StatelessWidget {
  const DisplayImages({super.key});

  Uint8List _base64ToImage(String base64String) {
    return base64Decode(base64String);
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    final crossAxisCount = w >= 1000 ? 4 : (w >= 700 ? 3 : 2);

    final gridPad = (w * 0.04).clamp(10.0, 24.0);
    final spacing = (w * 0.03).clamp(8.0, 16.0);

    final avatarSize = (w / crossAxisCount * 0.55).clamp(70.0, 140.0);

    final textSize = (w * 0.045).clamp(14.0, 20.0);
    final deleteBtnSize = (w * 0.08).clamp(28.0, 36.0);
    final deleteIconSize = (deleteBtnSize * 0.6).clamp(16.0, 20.0);

    if (user == null) {
      return const Center(child: Text("Please log in to view your photos."));
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('photos')
          .where('userId', isEqualTo: user.uid)
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No images found."));
        }

        final documents = snapshot.data!.docs;

        return GridView.builder(
          padding: EdgeInsets.symmetric(horizontal: gridPad, vertical: gridPad),
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
            childAspectRatio: w >= 700 ? 0.88 : 0.78,
          ),
          itemCount: documents.length,
          itemBuilder: (context, index) {
            final doc = documents[index];
            final data = doc.data() as Map<String, dynamic>;
            final docId = doc.id;

            final base64String = (data['image'] ?? '') as String;
            final description = (data['description'] ?? '') as String;

            return Stack(
              children: [
                Card(
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  color: const Color.fromRGBO(252, 242, 211, 1),
                  child: Padding(
                    padding: EdgeInsets.all((w * 0.03).clamp(10.0, 14.0)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: avatarSize,
                          height: avatarSize,
                          child: ClipOval(
                            child: Image.memory(
                              _base64ToImage(base64String),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(height: (h * 0.012).clamp(8.0, 12.0)),
                        SizedBox(
                          height: (h * 0.07).clamp(40.0, 55.0),
                          child: Center(
                            child: Text(
                              description,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: textSize,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(999),
                      onTap: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          barrierDismissible: true,
                          builder: (dialogContext) {
                            return AlertDialog(
                              title: const Text("Delete face"),
                              content: const Text(
                                "Are you sure you want to delete this face?",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(dialogContext).pop(false),
                                  child: const Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(dialogContext).pop(true),
                                  child: const Text(
                                    "Delete",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            );
                          },
                        );

                        if (confirm == true) {
                          await FirebaseFirestore.instance
                              .collection('photos')
                              .doc(docId)
                              .delete();
                        }
                      },
                      child: Container(
                        width: deleteBtnSize,
                        height: deleteBtnSize,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.95),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close,
                          size: deleteIconSize,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
