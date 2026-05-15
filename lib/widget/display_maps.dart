import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class disMaps extends StatelessWidget {
  const disMaps({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    final isTablet = w >= 700;
    final crossAxisCount = w >= 1000 ? 4 : (w >= 700 ? 3 : 2);

    final gridPad = (w * 0.04).clamp(10.0, 24.0);
    final spacing = (w * 0.03).clamp(8.0, 16.0);

    final titleSize = (isTablet ? w * 0.02 : w * 0.04).clamp(12.0, 16.0);

    if (user == null) {
      return const Center(child: Text("Please sign in first"));
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("maps")
          .where("ownerId", isEqualTo: user.uid)
          .orderBy("createdAt", descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No maps yet"));
        }

        final docs = snapshot.data!.docs;

        return GridView.builder(
          padding: EdgeInsets.symmetric(horizontal: gridPad, vertical: gridPad),
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
            childAspectRatio: w >= 700 ? 0.95 : 0.9,
          ),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;

            final String mapName = (data["mapName"] ?? "Map").toString();
            final String? imageBase64 = data["imageBase64"] as String?;
            final String? imageUrl = data["imageUrl"] as String?;

            Widget imageWidget;

            if (imageBase64 != null && imageBase64.isNotEmpty) {
              try {
                final bytes = base64Decode(imageBase64);
                imageWidget = Image.memory(bytes, fit: BoxFit.cover);
              } catch (_) {
                imageWidget = const Center(child: Text("Invalid Image"));
              }
            } else if (imageUrl != null && imageUrl.isNotEmpty) {
              imageWidget = Image.network(imageUrl, fit: BoxFit.cover);
            } else {
              imageWidget = const Center(child: Text("No Image"));
            }

            void openViewer() {
              if ((imageBase64 == null || imageBase64.isEmpty) &&
                  (imageUrl == null || imageUrl.isEmpty)) return;

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MapViewer(
                    imageBase64: imageBase64,
                    imageUrl: imageUrl,
                    title: mapName,
                  ),
                ),
              );
            }

            return GestureDetector(
              onTap: openViewer,
              child: Card(
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: const Color.fromRGBO(252, 242, 211, 1),
                child: Column(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                        child: imageWidget,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: (w * 0.02).clamp(8.0, 14.0),
                        vertical: (h * 0.01).clamp(6.0, 10.0),
                      ),
                      child: Text(
                        mapName,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: titleSize,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class MapViewer extends StatelessWidget {
  final String? imageBase64;
  final String? imageUrl;
  final String title;

  const MapViewer({
    super.key,
    required this.imageBase64,
    required this.imageUrl,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    Widget viewer;

    if (imageBase64 != null && imageBase64!.isNotEmpty) {
      try {
        final bytes = base64Decode(imageBase64!);
        viewer = Image.memory(bytes);
      } catch (_) {
        viewer = const Center(child: Text("Invalid Image"));
      }
    } else if (imageUrl != null && imageUrl!.isNotEmpty) {
      viewer = Image.network(imageUrl!);
    } else {
      viewer = const Center(child: Text("No Image"));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color.fromARGB(255, 247, 206, 77),
        foregroundColor: Colors.black,
      ),
      body: Center(
        child: InteractiveViewer(child: viewer),
      ),
    );
  }
}
