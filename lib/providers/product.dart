import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//This changeNotifier keyword is used for providers
class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourtie;

  Product(
      {required this.id,
      required this.title,
      required this.description,
      required this.price,
      required this.imageUrl,
      required this.isFavourtie});

  void _setFavValue(bool newValue) {
    isFavourtie = newValue;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus(String token, String userId) async {
    final oldStatus = isFavourtie;
    isFavourtie = !isFavourtie;
    notifyListeners();
    final url = Uri.parse('your api');
    try {
      final response = await http.put(
        url,
        body: json.encode(
          isFavourtie,
        ),
      );
      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
      }
    } catch (error) {
      _setFavValue(oldStatus);
    }
  }
}
