// under_development.dart
// Under Development Page - This page is temporary. Will display the Title, Subtite, and links to GitHub, Privacy Policy, and Support.

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hidden_intelligence/web/pages/privacy_policy.dart';
import 'package:hidden_intelligence/web/pages/support.dart';
import 'package:url_launcher/url_launcher.dart';

class UnderDevelopment extends StatelessWidget {
  const UnderDevelopment({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // MARK: Title (Hidden Intelligence)
              const Text(
                'Hidden Intelligence',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // MARK: Subtitle (A Game with Trust Issues!)
              const Text(
                'A Game with Trust Issues!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),

              // Spacer
              const Spacer(),

              // MARK: Description (Under Development)
              SizedBox(
                width: 700,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: 'The ability to play the game online is currently under development. In the meantime, feel free to check out the source code on GitHub, read the Privacy Policy, or contact Support. We also have a mobile app available on the ',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      TextSpan(
                        text: 'Google Play Store',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          color: Colors.blue,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            // Open Google Play Store
                            final Uri url = Uri.parse('https://play.google.com/store/apps/details?id=com.joshualim.hiddeniq');
                            if (!await launchUrl(url)) {
                              // Show error message
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Error'),
                                    content: const Text('Could not open the URL.'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                      ),
                      TextSpan(
                        text: ' and ',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      TextSpan(
                        text: 'Apple App Store',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          color: Colors.blue,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            // Open Apple App Store
                            final Uri url = Uri.parse('https://apps.apple.com/us/app/hidden-intelligence/id6736437352');
                            if (!await launchUrl(url)) {
                              // Show error message
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Error'),
                                    content: const Text('Could not open the URL.'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                      ),
                      TextSpan(
                        text: '.',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Spacer
              const Spacer(),

              // MARK: GitHub
              GestureDetector(
                onTap: () async {
                  // Open GitHub
                  final Uri url = Uri.parse('https://github.com/joshualim30/hidden_intelligence');
                  if (!await launchUrl(url)) {
                    // Show error message
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Error'),
                          content: const Text('Could not open the URL.'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: const Text(
                  'GitHub',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
              ),

              // MARK: Privacy Policy
              GestureDetector(
                onTap: () {
                  // Open Privacy Policy
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) {
                        return const PrivacyPolicy();
                      },
                    ),
                  );
                },
                child: const Text(
                  'Privacy Policy',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
              ),

              // MARK: Support
              GestureDetector(
                onTap: () {
                  // Open Support
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) {
                        return const Support();
                      },
                    ),
                  );
                },
                child: const Text(
                  'Support',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
              ),

              // SizedBox
              const SizedBox(height: 20),

              // MARK: Version
              const Text(
                'Version 1.0.0 (b3)',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
