// join.dart
// Join Screen - Will allow the player to join a game by entering the game id.

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hidden_intelligence/mobile/gameplay/waiting_room.dart';

class JoinScreen extends StatefulWidget {
  const JoinScreen({
    super.key,
    required this.emoji,
    required this.deviceId,
    required this.username,
  });

  final String emoji;
  final String deviceId;
  final String username;

  @override
  State<JoinScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  // Variables
  TextEditingController gameIdController = TextEditingController();
  bool isLoading = false;

  // MARK: Join Game
  void _joinGame() {
    // Dismiss the keyboard
    FocusScope.of(context).unfocus();
    // Check if code is 8 alphanumeric characters with hyphen in the middle
    if (gameIdController.text.length != 9 ) {
      // Show an error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid Game ID'),
        ),
      );
      return;
    } else if (gameIdController.text[4] != '-') {
      // Show an error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid Game ID'),
        ),
      );
      return;
    }
    // Set loading state
    setState(() {
      isLoading = true;
    });
    // Create a player object
    final Player self = Player(
      emoji: widget.emoji,
      username: widget.username,
      deviceId: widget.deviceId,
      isHost: false,
      points: 0,
    );
    // Find the game
    final CollectionReference games =
        FirebaseFirestore.instance.collection('games');
    games.where('gameId', isEqualTo: gameIdController.text).limit(1).get().then(
      (QuerySnapshot querySnapshot) async {
        if (querySnapshot.docs.isNotEmpty) {
          // Get the game
          final DocumentSnapshot game = querySnapshot.docs.first;
          // Get the players
          final List<dynamic> players = game['players'];
          // Add the player
          players.add(self.toJson());
          // TESTING ONLY
          debugPrint('Players: $players');
          // Update the game
          await games.doc(game.id).update({
            'players': players,
          });
          // Navigate to the waiting room
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => WaitingRoomScreen(
                emoji: widget.emoji,
                username: widget.username,
                deviceId: widget.deviceId,
                gameId: gameIdController.text,
              ),
            ),
          );
        } else {
          // Show an error
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Game not found'),
            ),
          );
        }
        // Set loading state
        setState(() {
          isLoading = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Join Game'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: gameIdController,
              decoration: const InputDecoration(
                labelText: 'Game ID',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _joinGame,
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Join Game'),
            ),
          ],
        ),
      ),
    );
  }
}
