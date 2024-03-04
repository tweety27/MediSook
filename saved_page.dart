/// saved page

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SavedPage extends StatelessWidget {
  const SavedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          "Saved",
          style: TextStyle(color: Colors.black, fontSize: 28),
        ),
      ),
      body: Column(
        children: [
          // 검색
          Padding(
            padding: const EdgeInsets.only(
              top: 30,
              bottom: 10,
              left: 10,
              right: 10,
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: "저장된 항목 내 검색",
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                // 아이콘 버튼들
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        // 검색 버튼 클릭 시
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection('likedMedi').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              }

              var likedMedicines = snapshot.data!.docs;

              return Expanded(
                child: ListView.builder(
                  itemCount: likedMedicines.length,
                  itemBuilder: (context, index) {
                    var medicine = likedMedicines[index].data();
                    return ListTile(
                      title: Text(medicine['itemName']),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.delete,
                            ),
                            onPressed: () {
                              // 삭제 버튼 클릭 시
                              deleteLikedMedicine(likedMedicines[index].id);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
} // 약품 삭제 함수

Future<void> deleteLikedMedicine(String documentId) async {
  try {
    await FirebaseFirestore.instance
        .collection('likedMedi')
        .doc(documentId)
        .delete();
  } catch (e) {
    print('Error deleting liked medicine: $e');
  }
}
