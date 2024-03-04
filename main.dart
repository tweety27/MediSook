//import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:medi/diary_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:camera/camera.dart';

import 'auth_service.dart';
import 'home_page.dart';
import 'liked_medicine.dart';
import 'my_page.dart';
import 'saved_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  await Firebase.initializeApp(); // firebase 앱 시작

  // 사용 가능한 카메라 목록 가져오기
  List<CameraDescription> cameras = await availableCameras();

  // 카메라 api 연결
  //File imageFile = File('/Users/JAE111/grad_proj/sample_image.png');
  //await HomePage._uploadImageToServer(imageFile);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
        ChangeNotifierProvider(create: (context) => DiaryService(prefs)),
        ChangeNotifierProvider(create: (context) => LikedMedicineManager()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Medi(cameras: cameras), // 카메라 목록을 Medi 위젯에 전달
      ),
    ),
  );
}

class Medi extends StatefulWidget {
  final List<CameraDescription> cameras;

  const Medi({Key? key, required this.cameras}) : super(key: key); // 생성자 수정

  @override
  // ignore: library_private_types_in_public_api
  _MediState createState() => _MediState();
}

class _MediState extends State<Medi> {
  int currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: [
          SavedPage(),
          HomePage(
            cameras: [],
          ),
          MyPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (newIndex) {
          setState(() {
            currentIndex = newIndex;
          });
        },
        selectedItemColor: Colors.blueGrey,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: ""),
        ],
      ),
    );
  }
}
