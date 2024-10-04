// in_app_purchases.dart
// In-App Purchase Manager

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hidden_intelligence/main.dart';
import 'package:hidden_intelligence/resources/in_app_purchases/purchases_helper.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

// MARK: Remove Ads Purchase
class InAppPurchases extends ChangeNotifier {
  // MARK: Properties
  InAppPurchasesCounter counter;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  final iapConnection = IAPConnection.instance;
  StoreState storeState = StoreState.loading;
  List<PurchasableProduct> products = [];

  // MARK: Getters
  bool get removeAds => _removeAds;
  bool _removeAds = false;

  // MARK: Constructor
  InAppPurchases(this.counter) {
    final purchaseUpdated = iapConnection.purchaseStream;
    _subscription = purchaseUpdated.listen(
      _onPurchaseUpdate,
      onDone: _updateStreamOnDone,
      onError: _updateStreamOnError,
    );
    loadPurchases();
  }

  // MARK: Initialize
  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  // MARK: Buy
  Future<void> buy(PurchasableProduct product) async {
    final purchaseParam = PurchaseParam(productDetails: product.productDetails);
    await iapConnection.buyNonConsumable(purchaseParam: purchaseParam);
  }

  // MARK: On Purchase Update
  void _onPurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) async {
    for (var purchaseDetails in purchaseDetailsList) {
      await _handlePurchase(purchaseDetails);
    }
    notifyListeners();
  }

  // MARK: Handle Purchase
  Future<void> _handlePurchase(PurchaseDetails purchaseDetails) async {
    // If purchase is pending, complete the purchase
    if (purchaseDetails.status == PurchaseStatus.purchased) {
      switch (purchaseDetails.productID) {
        case "remove_ads":
          _removeAds = true;
        case "small_intelligence":
          counter.addBoughtIntelligence(100);
        case "medium_intelligence":
          counter.addBoughtIntelligence(600);
        case "large_intelligence":
          counter.addBoughtIntelligence(1250);
      }
    }

    // If pending complete purchase, complete the purchase
    if (purchaseDetails.pendingCompletePurchase) {
      await iapConnection.completePurchase(purchaseDetails);
    }
  }

  // MARK: Update Stream on Done
  void _updateStreamOnDone() {
    _subscription.cancel();
  }

  // MARK: Update Stream on Error
  void _updateStreamOnError(dynamic error) {
    debugPrint('Error with purchase stream: $error');
  }

  // MARK: Load Purchases
  Future<void> loadPurchases() async {
    // Check if in-app purchases are available
    final available = await iapConnection.isAvailable();
    if (!available) {
      storeState = StoreState.notAvailable;
      notifyListeners();
      return;
    }

    // Load products
    const ids = <String>{
      "remove_ads",
      "small_intelligence",
      "medium_intelligence",
      "large_intelligence",
    };

    // Query product details
    final response = await iapConnection.queryProductDetails(ids);
    for (var element in response.notFoundIDs) {
      debugPrint('Purchase $element not found');
    }

    // Set products
    products = response.productDetails.map((e) => PurchasableProduct(e)).toList();
    storeState = StoreState.available;

    // Check if user has already bought remove ads
    notifyListeners();
  }
}

class InAppPurchasesCounter extends ChangeNotifier {
  // MARK: Properties
  final numberFormatter = NumberFormat.compactLong();

  // MARK: Getters
  int get count => _count.floor();
  String get countString => _countString;
  String _countString = '0';
  double _count = 0;
  late Timer timer;

  // MARK: Constructor
  InAppPurchasesCounter();

  // MARK: Initialize
  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  // MARK: Increment
  void increment() {
    _increment(1);
  }

  // MARK: Increment Count of Bought Intelligence
  void _increment(double increment) {
    var oldCount = _countString;
    _count += increment;
    _countString = numberFormatter.format(count);
    if (_countString != oldCount) {
      notifyListeners();
    }
  }

  // MARK: Add Bought Intelligence
  void addBoughtIntelligence(int amount) {
    _increment(amount.toDouble());
  }
}