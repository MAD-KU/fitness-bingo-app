import 'package:application/controllers/achievements_controller.dart';
import 'package:application/models/user_model.dart';
import 'package:application/screens/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/auth_controller.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  late AuthController authController;
  late UserModel currentUser;

  @override
  void initState() {
    super.initState();
    authController = Provider.of<AuthController>(context, listen: false);
    if (authController.currentUser == null) {
      authController.getCurrentUser();
    }
    currentUser = authController.currentUser!;

    // Fetch achievements for the current user
    final currentUserId = authController.currentUser?.id;
    if (currentUserId != null) {
      Provider.of<AchievementController>(context, listen: false)
          .fetchAchievementsForUser(currentUserId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: currentUser.imageUrl!.startsWith('http')
                          ? NetworkImage(currentUser.imageUrl!)
                          : AssetImage(currentUser.imageUrl!) as ImageProvider,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      currentUser.name!,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      currentUser.email!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit profile'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.notifications),
                title: const Text('Notifications'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {},
              ),
              const SizedBox(height: 20),
              // Achievements Section
              Consumer<AchievementController>(
                builder: (context, achievementController, child) {
                  if (achievementController.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (achievementController.errorMessage.isNotEmpty) {
                    return Center(
                        child: Text(achievementController.errorMessage));
                  }

                  if (achievementController.achievements.isEmpty) {
                    return const Center(
                        child: Text("No achievements yet."));
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          "Achievements",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: achievementController.achievements.length,
                        itemBuilder: (context, index) {
                          final achievement =
                          achievementController.achievements[index];
                          return ListTile(
                            leading: Icon(Icons.star, color: Colors.amber),
                            title: Text(achievement.title ?? 'No Title'),
                            subtitle: Text(
                                achievement.description ?? 'No Description'),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),

              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Sign Out'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  authController.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => SigninScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}