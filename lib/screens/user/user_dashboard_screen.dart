import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:application/widgets/chat_widget.dart';
import 'package:application/widgets/user_profile.dart';
import 'package:application/screens/user/article/articles_screen.dart';
import 'package:application/screens/user/bingo_card/user_bingocard_manage_screen.dart';

class UserDashboardScreen extends StatefulWidget {
  const UserDashboardScreen({Key? key}) : super(key: key);

  @override
  State<UserDashboardScreen> createState() => _UserDashboardScreenState();
}

class _UserDashboardScreenState extends State<UserDashboardScreen> {
  String? userId;

  @override
  void initState() {
    super.initState();
    // Get the userId from FirebaseAuth
    userId = FirebaseAuth.instance.currentUser?.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(  // Wrapped with Stack
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UserProfileSection(),
                  const SizedBox(height: 30),
                  GridView.count(
                    shrinkWrap: true,
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
                        onTap: () {},
                      ),
                      _buildDashboardCard(
                        context,
                        icon: Icons.article,
                        title: 'Articles',
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ArticlesScreen()));
                        },
                      ),
                      _buildDashboardCard(
                        context,
                        icon: Icons.store,
                        title: 'Store',
                        onTap: () {} ,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Add ChatWidget here
            Align(
              alignment: Alignment.bottomRight,
              child: userId == null
                  ? const CircularProgressIndicator()  // Show loading if userId is not available
                  : ChatWidget(userId: userId!), // Pass the dynamic userId
            ),
          ],
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
}
