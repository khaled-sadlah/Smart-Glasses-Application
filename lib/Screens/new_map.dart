import 'package:flutter/material.dart';
import 'package:senior/Screens/upload_map_base64.dart';

class NewMap extends StatefulWidget {
  const NewMap({super.key});

  @override
  State<NewMap> createState() => _NewMapState();
}

class _NewMapState extends State<NewMap> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    final isTablet = w >= 700;

    final appBarTitleSize = (isTablet ? w * 0.035 : w * 0.06).clamp(22.0, 34.0);
    final headerTextSize = (isTablet ? w * 0.04 : w * 0.075).clamp(22.0, 34.0);

    final headerHeight = (h * 0.26).clamp(170.0, 240.0);
    final imageSize = (headerHeight * 0.65).clamp(90.0, 160.0);

    final cardRadius = 20.0;

    final addBoxSize = (isTablet ? w * 0.22 : w * 0.38).clamp(120.0, 190.0);
    final addIconSize = (addBoxSize * 0.85).clamp(80.0, 170.0);

    final pad = (w * 0.05).clamp(14.0, 26.0);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 247, 206, 77),
        title: Text(
          'Maps',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: appBarTitleSize,
          ),
        ),
      ),
      body: Container(
        color: const Color.fromARGB(255, 247, 206, 77),
        child: Column(
          children: [
            SizedBox(
              height: headerHeight,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    image: const AssetImage('assets/p9.png'),
                    height: imageSize,
                    width: imageSize,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: (h * 0.01).clamp(6.0, 14.0)),
                  Text(
                    'Add new map',
                    style: TextStyle(
                      fontSize: headerTextSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20),
                      ),
                    ),
                  ),
                  Positioned(
                    top: pad,
                    left: pad,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const UploadMapBase64(),
                          ),
                        );
                      },
                      child: Container(
                        width: addBoxSize,
                        height: addBoxSize,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(247, 206, 77, 0.3),
                          borderRadius:
                              BorderRadius.all(Radius.circular(cardRadius)),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.add_rounded,
                            size: addIconSize,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
