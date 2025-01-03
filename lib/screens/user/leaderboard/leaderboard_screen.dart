import 'package:application/controllers/achievements_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({Key? key}) : super(key: key);

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<AchievementController>(context, listen: false)
        .fetchLeaderboardData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.black54, Colors.grey[900]!],
          ),
        ),
        child: Consumer<AchievementController>(
          builder: (context, achievementController, child) {
            if (achievementController.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (achievementController.errorMessage.isNotEmpty) {
              return Center(
                child: Text(
                  achievementController.errorMessage,
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            if (achievementController.leaderboardEntries.isEmpty) {
              return const Center(
                child: Text(
                  "No data available",
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            return ListView.separated(
              itemCount: achievementController.leaderboardEntries.length,
              separatorBuilder: (context, index) => Divider(
                color: Colors.grey[700],
                height: 1,
              ),
              itemBuilder: (context, index) {
                final entry = achievementController.leaderboardEntries[index];
                final isTopThree = index < 3;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    leading: _buildRankBadge(index),
                    title: Text(
                      entry.userName,
                      style: TextStyle(
                        color: isTopThree
                            ? Colors.amber[400]
                            : Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: isTopThree ? 18 : 16,
                      ),
                    ),
                    trailing: Text(
                      '${entry.score}',
                      style: TextStyle(
                        color: isTopThree
                            ? Colors.amber[400]
                            : Theme.of(context).primaryColor,
                        fontSize: isTopThree ? 22 : 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    tileColor: isTopThree
                        ? Colors.amber.withOpacity(0.2)
                        : Colors.transparent,
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildRankBadge(int index) {
    if (index < 3) {
      // Top 3 badges (Gold, Silver, Bronze)
      switch (index) {
        case 0:
          return CircleAvatar(
            backgroundColor: Colors.amber[400],
            child: const Icon(Icons.emoji_events, color: Colors.white),
          );
        case 1:
          return CircleAvatar(
            backgroundColor: Colors.grey[300],
            child: const Icon(Icons.emoji_events,
                color: Colors.black87), // Silver
          );
        case 2:
          return CircleAvatar(
            backgroundColor: Colors.brown[400],
            child: const Icon(Icons.emoji_events,
                color: Colors.white), // Bronze
          );
        default: // This won't be executed, but it's good to have a default case
          return const SizedBox.shrink();
      }
    } else {
      // For ranks 4 and below, use a darker background for the rank number
      return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey[800], // Darker background color
        ),
        child: Center(
          child: Text(
            '${index + 1}',
            style: const TextStyle(
              color: Colors.white, // White text color
              fontWeight: FontWeight.bold,
              fontSize: 18, // Larger font size
            ),
          ),
        ),
      );
    }
  }
}