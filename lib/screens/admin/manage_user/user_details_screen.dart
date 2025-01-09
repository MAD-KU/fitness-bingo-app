import 'package:application/controllers/user_controller.dart';
import 'package:application/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserDetailsScreen extends StatefulWidget {
  final String userId;

  const UserDetailsScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<UserController>(context, listen: false)
        .fetchUserById(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<UserController>(
            builder: (context, userController, child) {
              if (userController.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (userController.errorMessage.isNotEmpty) {
                return Center(child: Text(userController.errorMessage));
              }

              UserModel? user = userController.selectedUser;
              if (user == null) {
                return const Center(child: Text("User not found."));
              }

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage:
                        AssetImage('assets/images/profile.png'), // Hardcoded image
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildDetailCard(
                      context,
                      'Name',
                      user.name ?? 'N/A',
                      Icons.person,
                    ),
                    const SizedBox(height: 16),
                    _buildDetailCard(
                      context,
                      'Email',
                      user.email ?? 'N/A',
                      Icons.email,
                    ),
                    const SizedBox(height: 16),
                    _buildDetailCard(
                      context,
                      'Role',
                      user.role ?? 'N/A',
                      Icons.security,
                    ),
                    const SizedBox(height: 24),
                    // Removed _buildAdminActions
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDetailCard(
      BuildContext context, String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Theme.of(context).primaryColor,
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: Theme.of(context).primaryColor),
                ),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: Theme.of(context).primaryColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}