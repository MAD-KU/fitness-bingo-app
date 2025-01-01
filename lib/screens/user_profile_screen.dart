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
    authController = Provider.of<AuthController>(context, listen: false);
    if (authController.currentUser == null) {
      authController.getCurrentUser();
    }
    currentUser = authController.currentUser!;

    super.initState();
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
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Sign Out'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  authController.signOut();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => SigninScreen()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
