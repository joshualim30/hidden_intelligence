// home.dart
// Home Screen - Will show allow the player to see settings, host/join a game, change their username, and browse expansion packs.

import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hidden_intelligence/resources/html/adsense.dart';
import 'package:hidden_intelligence/web/gameplay/waiting_room.dart';
import 'package:hidden_intelligence/web/navigation/join.dart';
import 'package:hidden_intelligence/web/navigation/inapp.dart';
import 'package:hidden_intelligence/web/navigation/settings.dart';

class HomeScreenWeb extends StatefulWidget {
  const HomeScreenWeb({
    super.key,
  });

  @override
  State<HomeScreenWeb> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreenWeb> {
  // Variables
  String emoji = '😀';
  TextEditingController usernameController = TextEditingController();
  String? deviceId;
  String? username;

  // MARK: Init State
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  // MARK: Initialize App
  Future<void> _initializeApp() async {
    // Set Device ID to random cryptographically secure ID
    deviceId = Random.secure().nextInt(1000000000).toString();

    // Get Cookies
    // final cookie = document.cookie;
    // username = prefs.getString('username');

    // If Username is Null, use Device ID to seed random username
    if (username == null || username!.isEmpty) {
      // Get Device ID (integers only)
      final String deviceIdIntegers = deviceId!.replaceAll(RegExp(r'\D+'), '');
      final int deviceIdIntegersInt = int.parse(deviceIdIntegers);
      // Set Username plus all digits of Device ID
      username = 'Player$deviceIdIntegersInt';
      // prefs.setString('username', username!);
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
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // MARK: Subtitle
                  const Text(
                    'A Game with Trust Issues!',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.grey,
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
                                debugPrint('Username: $username');
                              });
                              // final SharedPreferences prefs =
                              //     await SharedPreferences.getInstance();
                              // prefs.setString('username', username!);
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
                                backgroundColor:
                                    Theme.of(context).colorScheme.onSurface,
                                foregroundColor:
                                    Theme.of(context).colorScheme.surface,
                              ),
                              onPressed: () {
                                Navigator.pushNamed(context, '/waiting_room');
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
                                  backgroundColor:
                                      Theme.of(context).colorScheme.onSurface,
                                  foregroundColor:
                                      Theme.of(context).colorScheme.surface,
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(context, '/join');
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

                  // AdSense Ads
                  adsenseAdsView(AdType.horizontal),

                  // MARK: Footer Row
                  // If width is greater than 1000
                  if (MediaQuery.of(context).size.width > 1000)
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Row(
                        children: <Widget>[
                          // MARK: Copyright
                          const Text(
                            '© 2024 Joshua Lim. All Rights Reserved.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),

                          // SizedBox
                          const SizedBox(width: 20),

                          // MARK: Privacy Policy
                          const Text(
                            'By using this app, you agree to our ',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/privacy_policy');
                            },
                            child: const Text(
                              'Privacy Policy',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue,
                              ),
                            ),
                          ),

                          // Spacer
                          const Spacer(),

                          // MARK: Version
                          const Text(
                            'Version 1.0.0 (b3)',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),

                          // SizedBox
                          const SizedBox(width: 20),

                          // MARK: Support
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/support');
                            },
                            child: const Text(
                              'Support',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue,
                              ),
                            ),
                          ),

                          // SizedBox
                          const SizedBox(width: 20),

                          // MARK: About
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/about');
                            },
                            child: const Text(
                              'About',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // If width is less than 1000
                  if (MediaQuery.of(context).size.width < 1000)
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Column(
                        children: <Widget>[
                          // MARK: Copyright
                          const Text(
                            '© 2024 Joshua Lim. All Rights Reserved.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),

                          // SizedBox
                          const SizedBox(width: 20),

                          // MARK: Version
                          const Text(
                            'Version 1.0.0 (b3)',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),

                          // SizedBox
                          const SizedBox(width: 20),

                          // MARK: Privacy Policy
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/privacy_policy');
                            },
                            child: const Text(
                              'Privacy Policy',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue,
                              ),
                            ),
                          ),

                          // SizedBox
                          const SizedBox(width: 20),

                          // MARK: Support
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/support');
                            },
                            child: const Text(
                              'Support',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue,
                              ),
                            ),
                          ),

                          // SizedBox
                          const SizedBox(width: 20),

                          // MARK: About
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/about');
                            },
                            child: const Text(
                              'About',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
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
