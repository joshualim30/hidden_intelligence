// purchases_helper.dart
// In App Purchases Helper

import 'package:in_app_purchase/in_app_purchase.dart';

enum StoreState {
  loading,
  available,
  notAvailable,
}

enum ProductStatus {
  purchasable,
  purchased,
  pending,
}

class PurchasableProduct {
  String get id => productDetails.id;
  String get title => productDetails.title;
  String get description => productDetails.description;
  String get price => productDetails.price;
  ProductStatus status;
  ProductDetails productDetails;

  PurchasableProduct(this.productDetails) : status = ProductStatus.purchasable;
}
