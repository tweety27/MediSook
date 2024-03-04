// models/medicine.dart

class Medicine {
  final String itemName;
  final String itemImage;
  bool isFavorite;

  Medicine({
    required this.itemName,
    required this.itemImage,
    this.isFavorite = false,
  });
}
