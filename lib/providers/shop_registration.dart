import 'package:flutter/material.dart';

class ShopRegistrationProvider {
  PageController? pageController;
  bool isAdds = true;
  ShopRegistrationProvider() {
    pageController = PageController();
  }
}

class AdsProvider with ChangeNotifier {
  bool _showAds = true;

  void refresh() {
    _showAds = true;
    notifyListeners();
  }

  void cancelAds({bool? value}) {
    _showAds = value ?? false;
  }

  bool get showAds => _showAds;
}
