import 'package:application/screens/admin/manage_bingo_cards_screen.dart';
import 'package:application/screens/admin/store_screen.dart';
import 'package:application/widgets/user_profile.dart';
import 'package:flutter/material.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const UserProfileSection(),
              const SizedBox(height: 30),

              // Options for Admin
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildDashboardCard(
                    context,
                    icon: Icons.people,
                    title: 'Users',
                    onTap: () {},
                  ),
                  _buildDashboardCard(
                    context,
                    icon: Icons.card_giftcard,
                    title: 'Bingo Cards',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ManageBingoCardsScreen()));
                    },
                  ),
                  _buildDashboardCard(
                    context,
                    icon: Icons.article,
                    title: 'Articles',
                    onTap: () {},
                  ),
                  _buildDashboardCard(
                    context,
                    icon: Icons.store,
                    title: 'Store',
                    onTap: () {Navigator.push(
                    context,
                    MaterialPageRoute(
                    builder: (context) => AdminStoreScreen()));
                   },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Dashboard Card Widget
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
