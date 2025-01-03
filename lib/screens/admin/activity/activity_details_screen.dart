import 'package:application/screens/admin/activity/activity_edit_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:application/controllers/activity_controller.dart';

class ActivityDetailsScreen extends StatefulWidget {
  final String activityId;

  const ActivityDetailsScreen({Key? key, required this.activityId})
      : super(key: key);

  @override
  State<ActivityDetailsScreen> createState() => _ActivityDetailsScreenState();
}

class _ActivityDetailsScreenState extends State<ActivityDetailsScreen> {
  late ActivityController activityController;
  String? userId = FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    super.initState();
    activityController =
        Provider.of<ActivityController>(context, listen: false);
    activityController.getActivityById(widget.activityId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity Details'),
        backgroundColor: Colors.transparent,
      ),
      body: Consumer<ActivityController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.errorMessage != null) {
            return Center(child: Text(controller.errorMessage!));
          }

          final activity = controller.activity;

          if (activity == null) {
            return const Center(child: Text('No data found.'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      image: activity.imageUrl != null &&
                              activity.imageUrl!.isNotEmpty &&
                              activity.imageUrl!.contains("http")
                          ? NetworkImage(activity.imageUrl!)
                          : const AssetImage('assets/images/default1.jpg')
                              as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  activity.name ?? 'No Name',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.check_circle, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Status: ${activity.status ?? 'N/A'}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.category, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Category: ${activity.category ?? 'N/A'}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.person, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'User ID: ${activity.userId ?? 'N/A'}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (userId == activity.userId)
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ActivityEditScreen(
                                        activityId: widget.activityId)));
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: Theme.of(context).primaryColor,
                          ),
                          child: const Text(
                            'Edit',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            activityController.deleteActivity(activity.id!);
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: Colors.redAccent,
                          ),
                          child: const Text(
                            'Delete',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
