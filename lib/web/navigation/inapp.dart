// inapp.dart
// In App Store - Show users the options to remove ads, purchase coins, or unlock premium features.

import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class InAppScreen extends StatelessWidget {
  const InAppScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('In App Store'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text('Remove Ads'),
            Text('Purchase Coins'),
            Text('Unlock Premium Features'),
          ],
        ),
      ),
    );
  }
}