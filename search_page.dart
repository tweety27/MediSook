/// search page
// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'medicine_detail.dart';
import 'liked_medicine.dart';

class SearchPage extends StatefulWidget {
  final String searchTerm;

  const SearchPage({Key? key, required this.searchTerm}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Map<String, dynamic>> searchResults = [];
  late TextEditingController searchController;

  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController(text: widget.searchTerm);
    // 검색 결과를 가져오는 함수 호출
    searchMedicine();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: "검색어를 입력하세요", // 검색어 힌트 변경
            border: InputBorder.none,
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
                    // 카메라 버튼 클릭
                  },
                ),
              ],
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(
            CupertinoIcons.chevron_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView.builder(
        itemCount: searchResults.length,
        itemBuilder: (context, index) {
          String imageUrl = searchResults[index]['itemImage'] ?? '';

          return ListTile(
            leading: imageUrl.isNotEmpty
                ? Image.network(imageUrl)
                : Icon(Icons.medication_liquid_rounded), // 이미지 없을 경우 아이콘 표시
            title: Text(searchResults[index]['itemName']),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.thumb_up,
                    color: searchResults[index]['isFavorite']
                        ? Colors.indigo
                        : Colors.black,
                  ),
                  onPressed: () {
                    setState(() {
                      searchResults[index]['isFavorite'] =
                          !searchResults[index]['isFavorite'];
                    });

                    final medicineName = searchResults[index]['itemName'];

                    if (searchResults[index]['isFavorite']) {
                      Provider.of<LikedMedicineManager>(context, listen: false)
                          .addLikedMedicine(medicineName);
                    } else {
                      Provider.of<LikedMedicineManager>(context, listen: false)
                          .removeLikedMedicine(medicineName);
                    }

                    saveLikedMedicine(searchResults[index]);
                  },
                ),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MedicineDetailPage(
                    medicineDetails: searchResults[index],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> searchMedicine() async {
    final response = await http.get(
      Uri.parse('http://localhost:3000/search/${widget.searchTerm}'),
    );

    if (response.statusCode == 200) {
      // 서버로부터 받은 JSON을 List<Map>으로 변환
      final List<dynamic> data = json.decode(response.body);

      setState(() {
        // 검색 결과 업데이트
        searchResults = List<Map<String, dynamic>>.from(data)
            .map((medicine) => {'isFavorite': false, ...medicine})
            .toList();
      });
    } else {
      // 오류 처리
      print('검색 오류: ${response.statusCode}');
    }
  }
}

// Function to save liked medicine to Firebase
Future<void> saveLikedMedicine(Map<String, dynamic> medicine) async {
  try {
    // 약품이 이미 저장되어 있는지 확인
    final querySnapshot = await FirebaseFirestore.instance
        .collection('likedMedi')
        .where('itemName', isEqualTo: medicine['itemName'])
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // 이미 저장되어 있다면 삭제
      await querySnapshot.docs.first.reference.delete();
    } else {
      // 저장되어 있지 않다면 추가
      await FirebaseFirestore.instance.collection('likedMedi').add({
        'itemName': medicine['itemName'],
        'isFavorite': true,
        // Add other fields you want to store
      });
    }
  } catch (e) {
    print('Error saving liked medicine: $e');
  }
}
