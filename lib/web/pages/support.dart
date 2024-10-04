// support.dart
// Support Page

import 'package:flutter/material.dart';

class Support extends StatelessWidget {
  const Support({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Support'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            // MARK: Description (Contact Support)
            const SizedBox(
              width: 700,
              child: Text(
                'If you have any questions, concerns, or feedback, please feel free to contact us at:',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),

            // Spacer
            const SizedBox(height: 20),

            // MARK: Email
            GestureDetector(
              onTap: () async {
                // Open Email
              },
              child: const Text(
                'joshualim3612@gmail.com',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        )
      ),
    );
  }
}