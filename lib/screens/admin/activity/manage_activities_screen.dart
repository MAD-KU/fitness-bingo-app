import 'package:application/screens/admin/activity/activity_details_screen.dart';
import 'package:application/screens/admin/activity/add_activity_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:application/models/activity_model.dart';
import 'package:application/controllers/activity_controller.dart';
import 'package:application/controllers/auth_controller.dart';
import 'package:application/models/user_model.dart';

import '../../../models/bingocard_model.dart';

class ManageActivitiesScreen extends StatefulWidget {
  final BingoCardModel bingoCard;

  const ManageActivitiesScreen({Key? key, required this.bingoCard})
      : super(key: key);

  @override
  State<ManageActivitiesScreen> createState() => _ManageActivitiesScreenState();
}

class _ManageActivitiesScreenState extends State<ManageActivitiesScreen> {
  late ActivityController activityController;
  late UserModel user;

  @override
  void initState() {
    super.initState();
    user = Provider.of<AuthController>(context, listen: false).currentUser!;
    activityController =
        Provider.of<ActivityController>(context, listen: false);
    activityController.getAllActivities(widget.bingoCard.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Activities'),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Consumer<ActivityController>(
          builder: (context, controller, child) {
            if (controller.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.errorMessage != null) {
              return Center(child: Text(controller.errorMessage!));
            }

            return Column(
              children: [
                const SizedBox(height: 20),
                Expanded(
                  child: GridView.builder(
                    itemCount: controller.activities.length + 1,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return _buildActivityCard(
                          context,
                          icon: Icons.add,
                          title: 'Add Activity',
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddActivityScreen(
                                          bingoCard: widget.bingoCard,
                                        )));
                          },
                          image: user.imageUrl,
                        );
                      } else {
                        ActivityModel activity =
                            controller.activities[index - 1];
                        return _buildActivityCard(
                          context,
                          icon: Icons.star,
                          title: activity.name ?? 'No Name',
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ActivityDetailsScreen(
                                        activityId: activity.id!)));
                          },
                          image: activity.imageUrl ?? '',
                        );
                      }
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildActivityCard(BuildContext context,
      {required IconData icon,
      required String title,
      required VoidCallback onTap,
      String? image}) {
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
          image: image != null && image.isNotEmpty
              ? DecorationImage(
                  image: NetworkImage(image),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.7),
                    BlendMode.darken,
                  ),
                )
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
