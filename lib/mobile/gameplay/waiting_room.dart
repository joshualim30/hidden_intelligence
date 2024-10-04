// waiting_room.dart
// Waiting Room - Allow users to wait for other players to join the game, if host, can start the game.

import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hidden_intelligence/mobile/gameplay/game.dart';

class WaitingRoomScreen extends StatefulWidget {
  const WaitingRoomScreen({
    super.key,
    required this.emoji,
    required this.username,
    required this.deviceId,
    this.gameId,
  });

  final String emoji;
  final String username;
  final String deviceId;
  final String? gameId;

  @override
  State<WaitingRoomScreen> createState() => _WaitingRoomScreenState();
}

class _WaitingRoomScreenState extends State<WaitingRoomScreen> {
  // Variables
  late Future<String> gameId;
  String? gameID;

  // Init State
  void initState() {
    super.initState();
    // Generate the game
    _generateGame().then((String gameId) {
      setState(() {
        debugPrint('Generated Game ID: $gameId');
        this.gameId = Future.value(gameId);
        gameID = gameId;
      });
    });
  }

  // MARK: Generate Game
  Future<String> _generateGame() async {
    debugPrint("Game ID: ${widget.gameId}");
    // If the gameId is null, then the user is the host
    if (widget.gameId == null) {
      // Generate a new game id
      final String gameId = await _generateGameId();
      // Create a player object
      final Player self = Player(
        emoji: widget.emoji,
        username: widget.username,
        deviceId: widget.deviceId,
        isHost: widget.gameId == null,
        points: 0,
      );
      // Create a new game object
      final Game game = Game(
        gameId: gameId,
        status: 'waiting', // waiting, in_progress, completed
        rounds: [],
        players: [
          self,
        ],
        aiPoints: 0,
      );
      // Create a new game object
      final CollectionReference games =
          FirebaseFirestore.instance.collection('games');
      games.doc(gameId).set(game.toJson());
      debugPrint('Game created with id: $gameId');
      return gameId;
    }

    // Else, return the gameId
    return widget.gameId!;
  }

  // MARK: Generate Game ID
  Future<String> _generateGameId() async {
    // Generate a random 8-digit alphanumeric string
    const String chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    String gameId =
        List.generate(8, (index) => chars[Random().nextInt(chars.length)])
            .join();
    // Separate the game id into two parts
    final String part1 = gameId.substring(0, 4);
    final String part2 = gameId.substring(4, 8);
    // Combine the parts with a hyphen
    gameId = '$part1-$part2';

    // Check if the game id already exists
    final CollectionReference games =
        FirebaseFirestore.instance.collection('games');
    games.doc(gameId).get().then((DocumentSnapshot documentSnapshot) async {
      if (documentSnapshot.exists) {
        // If the game id already exists, generate a new one
        return await _generateGameId();
      }
    });

    // Return the game id
    return gameId.toUpperCase();
  }

  // MARK: Leave Game
  Future<void> _leaveGame() async {
    // Remove the player from the game
    final CollectionReference games =
        FirebaseFirestore.instance.collection('games');
    games.where('gameId', isEqualTo: widget.gameId).limit(1).get().then(
      (QuerySnapshot querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          // Get the game
          final DocumentSnapshot game = querySnapshot.docs.first;
          // Get the players
          final List<dynamic> players = game['players'];
          // Remove the player
          players
              .removeWhere((player) => player['deviceId'] == widget.deviceId);
          // Update the game
          games.doc(game.id).update({
            'players': players,
          });
        }
      },
    );
    // If last player, or host, delete the game
    games.where('gameId', isEqualTo: widget.gameId).limit(1).get().then(
      (QuerySnapshot querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          // Get the game
          final DocumentSnapshot game = querySnapshot.docs.first;
          // Get the players
          final List<dynamic> players = game['players'];
          // If last player, or host, delete the game
          if (players.isEmpty ||
              players
                  .every((player) => player['deviceId'] == widget.deviceId)) {
            games.doc(game.id).delete();
          }
        }
      },
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Waiting Room (${gameID ?? 'Loading...'})'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Show an alert dialog
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Leave Game?'),
                    content:
                        const Text('Are you sure you want to leave the game?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          // Handle leaving the game
                          _leaveGame();
                          // Pop the screen
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        child: const Text('Yes'),
                      ),
                      TextButton(
                        onPressed: () {
                          // Pop the alert dialog
                          Navigator.of(context).pop();
                        },
                        child: const Text('No'),
                      ),
                    ],
                  );
                });
          },
        ),
      ),
      body: FutureBuilder(
        future: gameId,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('games')
                    .doc(snapshot.data)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      // Check if game has started
                      if (snapshot.data!['status'] == 'in_progress') {
                        // Navigate to the game screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => GameScreen(
                              gameId: snapshot.data!.id,
                              player: Player(
                                emoji: widget.emoji,
                                username: widget.username,
                                deviceId: widget.deviceId,
                                isHost: widget.gameId == null,
                                points: 0,
                              ),
                            ),
                          ),
                        );
                      }

                      final DocumentSnapshot game = snapshot.data!;
                      final List<dynamic> players = game['players'];
                      final bool isHost = players.firstWhere((player) =>
                          player['deviceId'] == widget.deviceId)['isHost'];

                      // Waiting Room UI
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Column(
                          children: <Widget>[
                            // List of Players
                            Expanded(
                              child: ListView.builder(
                                itemCount: players.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final Player player = Player(
                                    emoji: players[index]['emoji'],
                                    username: players[index]['username'],
                                    deviceId: players[index]['deviceId'],
                                    isHost: players[index]['isHost'],
                                    points: players[index]['points'],
                                  );
                                  return ListTile(
                                    tileColor:
                                        player.deviceId == widget.deviceId
                                            ? Colors.blue[100]
                                            : null,
                                    leading: Text(player.emoji),
                                    title: Text(player.username),
                                    subtitle:
                                        Text(player.isHost ? 'Host' : 'Player'),
                                  );
                                },
                              ),
                            ),

                            // Start Game Button (says "waiting" if not host)
                            // If not host, the button is disabled
                            ElevatedButton(
                              onPressed: isHost
                                  ? () {
                                      // Update the game status
                                      FirebaseFirestore.instance
                                          .collection('games')
                                          .doc(game.id)
                                          .update({
                                        'status': 'in_progress',
                                      });
                                    }
                                  : null,
                              child: Text(isHost ? 'Start Game' : 'Waiting'),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return const Text('Error checking if you are the host.');
                    }
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              );
            } else {
              return const Text('Error checking if you are the host.');
            }
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}

// MARK: Game Structure
class Game {
  Game({
    required this.gameId,
    required this.status,
    required this.rounds,
    required this.players,
    required this.aiPoints,
  });

  final String gameId;
  final String status;
  List<Round> rounds;
  final List<Player> players;
  int aiPoints;

  // To JSON
  Map<String, dynamic> toJson() => {
        'gameId': gameId,
        'status': status,
        'rounds': rounds.map((round) => round.toJson()).toList(),
        'players': players.map((player) => player.toJson()).toList(),
        'aiPoints': aiPoints,
      };

  // From JSON
  factory Game.fromJson(Map<String, dynamic> json) => Game(
        gameId: json['gameId'],
        status: json['status'],
        rounds: List<Round>.from(
            json['rounds'].map((round) => Round.fromJson(round))),
        players: List<Player>.from(
            json['players'].map((player) => Player.fromJson(player))),
        aiPoints: json['aiPoints'],
      );
}

// MARK: Player Structure
class Player {
  Player({
    required this.emoji,
    required this.username,
    required this.deviceId,
    required this.isHost,
    required this.points,
  });

  final String emoji;
  final String username;
  final String deviceId;
  final bool isHost;
  int points;

  // To JSON
  Map<String, dynamic> toJson() => {
        'emoji': emoji,
        'username': username,
        'deviceId': deviceId,
        'isHost': isHost,
        'points': points,
      };

  // From JSON
  factory Player.fromJson(Map<String, dynamic> json) => Player(
        emoji: json['emoji'],
        username: json['username'],
        deviceId: json['deviceId'],
        isHost: json['isHost'],
        points: json['points'],
      );
}

// MARK: Round Structure
class Round {
  Round({
    required this.prompt,
    required this.responses,
    required this.aiResponse,
    required this.votes,
  });

  String prompt;
  final List<Response> responses;
  String aiResponse;
  List<Vote> votes;

  // To JSON
  Map<String, dynamic> toJson() => {
        'prompt': prompt,
        'responses': responses.map((response) => response.toJson()).toList(),
        'aiResponse': aiResponse,
        'votes': votes.map((vote) => vote.toJson()).toList(),
      };

  // From JSON
  factory Round.fromJson(Map<String, dynamic> json) => Round(
        prompt: json['prompt'],
        responses: List<Response>.from(
            json['responses'].map((response) => Response.fromJson(response))),
        aiResponse: json['aiResponse'],
        votes:
            List<Vote>.from(json['votes'].map((vote) => Vote.fromJson(vote))),
      );
}

// MARK: Response Structure
class Response {
  Response({
    required this.playerID,
    required this.response,
  });

  final String playerID;
  final String response;

  // To JSON
  Map<String, dynamic> toJson() => {
        'playerID': playerID,
        'response': response,
      };

  // From JSON
  factory Response.fromJson(Map<String, dynamic> json) => Response(
        playerID: json['playerID'],
        response: json['response'],
      );
}

// MARK: Vote Structure
class Vote {
  Vote({
    required this.playerID,
    required this.votes,
  });

  final String playerID;
  final List<String> votes;

  // To JSON
  Map<String, dynamic> toJson() => {
        'playerID': playerID,
        'votes': votes,
      };

  // From JSON
  factory Vote.fromJson(Map<String, dynamic> json) => Vote(
        playerID: json['playerID'],
        votes: List<String>.from(json['votes']),
      );
}
