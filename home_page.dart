/// home page
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:medi/search_page.dart';

import 'login_page.dart';

class HomePage extends StatelessWidget {
  final TextEditingController searchController = TextEditingController();
  final List<CameraDescription> cameras;

  HomePage({Key? key, required this.cameras}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          'Medi',
          style: TextStyle(color: Colors.black, fontSize: 28),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.login, color: Colors.black),
            onPressed: () {
              // Navigate to the login page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => LoginPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 100,
              bottom: 30,
              left: 8,
              right: 8,
            ),
            child: Text(
              "궁금한 의약품을\n검색하세요!",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 40,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "약품명을 검색해주세요.",
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        // 검색 버튼 클릭
                        final searchTerm = searchController.text;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SearchPage(searchTerm: searchTerm),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.camera_alt_rounded),
                      onPressed: () {
                        // 카메라 버튼 클릭 시
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Divider(height: 1),
        ],
      ),
    );
  }
}
