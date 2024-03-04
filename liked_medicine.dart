import 'package:flutter/material.dart';

class LikedMedicineManager extends ChangeNotifier {
  List<String> likedMedicines = [];

  void addLikedMedicine(String medicineName) {
    likedMedicines.add(medicineName);
    notifyListeners();
  }

  void removeLikedMedicine(String medicineName) {
    likedMedicines.remove(medicineName);
    notifyListeners();
  }

  bool isMedicineLiked(String medicineName) {
    return likedMedicines.contains(medicineName);
  }
}
