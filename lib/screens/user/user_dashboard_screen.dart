import 'package:application/controllers/achievements_controller.dart';
import 'package:application/screens/user/article/articles_screen.dart';
import 'package:application/screens/user/bingo_card/user_bingocard_manage_screen.dart';
import 'package:application/screens/user/leaderboard/leaderboard_screen.dart';
import 'package:application/widgets/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/auth_controller.dart';
import '../signin_screen.dart';

class UserDashboardScreen extends StatefulWidget {
  const UserDashboardScreen({Key? key}) : super(key: key);

  @override
  State<UserDashboardScreen> createState() => _UserDashboardScreenState();
}

class _UserDashboardScreenState extends State<UserDashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch achievements for the current user when the dashboard is initialized
    _fetchAchievements();
  }

  Future<void> _fetchAchievements() async {
    final currentUserId =
        Provider.of<AuthController>(context, listen: false).currentUser?.id;
    if (currentUserId != null) {
      await Provider.of<AchievementController>(context, listen: false)
          .fetchAchievementsForUser(currentUserId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserProfileSection(),
              const SizedBox(height: 30),
              GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(), // Added
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildDashboardCard(
                    context,
                    icon: Icons.card_giftcard,
                    title: 'Bingo Cards',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserBingoCardsScreen()));
                    },
                  ),
                  _buildDashboardCard(
                    context,
                    icon: Icons.leaderboard,
                    title: 'Leader Board',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LeaderboardScreen(),
                        ),
                      );
                    },
                  ),
                  _buildDashboardCard(
                    context,
                    icon: Icons.article,
                    title: 'Articles',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ArticlesScreen()));
                    },
                  ),
                  _buildDashboardCard(
                    context,
                    icon: Icons.store,
                    title: 'Store',
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 30),
              _buildRecentAchievementsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardCard(
      BuildContext context, {
        required IconData icon,
        required String title,
        required VoidCallback onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.8),
              Theme.of(context).primaryColor.withOpacity(0.5),
              Theme.of(context).cardColor.withOpacity(0.3),
            ],
            stops: [0.2, 0.5, 1.0],
            center: Alignment.topRight,
            radius: 0.7,
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).cardColor.withOpacity(0.7),
              spreadRadius: 2,
              blurRadius: 2,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: Theme.of(context).indicatorColor,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Theme.of(context).primaryColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentAchievementsSection() {
    return Consumer<AchievementController>(
      builder: (context, achievementController, child) {
        if (achievementController.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        if (achievementController.errorMessage.isNotEmpty) {
          return Center(child: Text(achievementController.errorMessage));
        }

        if (achievementController.achievements.isEmpty) {
          return SizedBox.shrink(); // Don't show the section if no achievements
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Recent Achievements",
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 150, // Adjust height as needed
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: achievementController.achievements.length,
                itemBuilder: (context, index) {
                  final achievement = achievementController.achievements[index];
                  return Container(
                    width: 200, // Adjust width as needed
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 24),
                        SizedBox(height: 8),
                        Text(
                          achievement.title ?? 'No Title',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          achievement.description ?? 'No Description',
                          style: TextStyle(
                            color: Theme.of(context)
                                .primaryColor
                                .withOpacity(0.8),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        // Add more details if necessary
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}