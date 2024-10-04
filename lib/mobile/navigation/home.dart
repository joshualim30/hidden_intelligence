// home.dart
// Home Screen - Will show allow the player to see settings, host/join a game, change their username, and browse expansion packs.

import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hidden_intelligence/mobile/gameplay/waiting_room.dart';
import 'package:hidden_intelligence/mobile/navigation/join.dart';
import 'package:hidden_intelligence/mobile/navigation/inapp.dart';
import 'package:hidden_intelligence/mobile/navigation/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({
    super.key,
    this.adSize = AdSize.banner,
  });

  final AdSize adSize;
  final String adUnitID = Platform.isAndroid
      ? 'ca-app-pub-8037794323311912/1213079781' // Android Ad Unit ID
      : 'ca-app-pub-8037794323311912/7227823795'; // iOS Ad Unit ID

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Variables
  String emoji = '😀';
  TextEditingController usernameController = TextEditingController();
  String? deviceId;
  String? username;
  BannerAd? _bannerAd;

  // MARK: Init State
  @override
  void initState() {
    super.initState();
    _loadAd(context);
  }

  // MARK: Load Ad
  void _loadAd(context) {
    final bannerAd = BannerAd(
      size: widget.adSize,
      adUnitId: widget.adUnitID,
      request: const AdRequest(),
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          if (!mounted) {
            ad.dispose();
            return;
          }
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, error) {
          debugPrint('BannerAd failed to load: $error');
          ad.dispose();
        },
      ),
    );

    // Start loading.
    bannerAd.load();
  }

  // MARK: Initialize App
  Future<void> _initializeApp() async {
    // Get Device ID
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceId = androidInfo.id;
    } else if (Platform.isIOS) {
      final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceId = iosInfo.identifierForVendor ?? 'Unknown iOS Device ID';
    }

    // Get Persistent Data
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    username = prefs.getString('username');

    // If Username is Null, use Device ID to seed random username
    if (username == null || username!.isEmpty) {
      // Get Device ID (integers only)
      final String deviceIdIntegers = deviceId!.replaceAll(RegExp(r'\D+'), '');
      final int deviceIdIntegersInt = int.parse(deviceIdIntegers);
      // Set Username plus all digits of Device ID
      username = 'Player$deviceIdIntegersInt';
      prefs.setString('username', username!);
    }

    // Set Username
    usernameController.text = username!;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeApp(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  // MARK: Title
                  const Text(
                    'Hidden Intelligence',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // Spacer
                  const Spacer(),

                  // MARK: Username
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: 60.0, right: 20.0, left: 20.0),
                    child: Row(
                      children: [
                        // Emoji Icon Selector
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              // TODO: Implement Emoji Picker
                            },
                            child: Text(
                              emoji,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 25,
                              ),
                            ),
                          ),
                        ),

                        const Spacer(),

                        SizedBox(
                          width: MediaQuery.of(context).size.width - 150,
                          height: 50,
                          child: TextField(
                            controller: usernameController,
                            decoration: const InputDecoration(
                              labelText: 'Username',
                            ),
                            onSubmitted: (value) async {
                              setState(() {
                                username = value;
                              });
                              final SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setString('username', username!);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Row
                  Row(
                    children: <Widget>[
                      // MARK: In App
                      IconButton(
                        iconSize: 30,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const InAppScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.shopping_cart),
                      ),

                      const Spacer(),

                      // MARK: Host/Join Stack
                      Column(
                        children: <Widget>[
                          SizedBox(
                            height: 50,
                            width: MediaQuery.of(context).size.width - 175,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).colorScheme.onSurface,
                                foregroundColor: Theme.of(context).colorScheme.surface,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => WaitingRoomScreen(
                                      emoji: emoji,
                                      username: username!,
                                      deviceId: deviceId!,
                                    ),
                                  ),
                                );
                              },
                              child: const Text('Host'),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(bottom: 20.0, top: 10.0),
                            child: SizedBox(
                              height: 50,
                              width: MediaQuery.of(context).size.width - 175,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context).colorScheme.onSurface,
                                  foregroundColor: Theme.of(context).colorScheme.surface,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => JoinScreen(
                                        emoji: emoji,
                                        deviceId: deviceId!,
                                        username: username!,
                                      ),
                                    ),
                                  );
                                },
                                child: const Text('Join'),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const Spacer(),

                      // MARK: Settings
                      IconButton(
                        iconSize: 30,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SettingsScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.settings),
                      ),
                    ],
                  ),

                  // MARK: Ad Banner
                  if (_bannerAd == null)
                    Container(
                      // color: Colors.blue,
                      height: 50,
                    )
                  else
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(widget.adSize.width <  MediaQuery.of(context).size.width ? 10 : 0,),
                      ),
                      clipBehavior: Clip.antiAlias,
                      height: widget.adSize.height.toDouble(),
                      width: widget.adSize.width.toDouble(),
                      child: AdWidget(ad: _bannerAd!),
                    ),
                ],
              ),
            ),
          );
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
