extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

extension DubouleExtension on String {
  double todouble() {
    return double.tryParse("") ?? 0.0;
  }
}
