/// medicine detail page
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MedicineDetailPage extends StatelessWidget {
  final Map<String, dynamic> medicineDetails;

  const MedicineDetailPage({Key? key, required this.medicineDetails})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          medicineDetails['itemName'],
          style: TextStyle(color: Colors.black, fontSize: 22),
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16), // 간격 추가
            _buildDetailItem("효능 효과", medicineDetails['efcyQesitm']),
            _buildDetailItem("복용 방법", medicineDetails['useMethodQesitm']),
            _buildDetailItem("주의 사항", medicineDetails['atpnQesitm']),
            //_buildDetailItem("부작용", medicineDetails['seQesitm']),
            _buildDetailItem("보관 방법", medicineDetails['depositMethodQesitm']),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String title, String content) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
