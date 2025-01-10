import 'package:application/controllers/track_activity_controller.dart';
import 'package:application/controllers/activity_controller.dart';
import 'package:application/controllers/track_bingocard_controller.dart';
import 'package:application/models/activity_model.dart';
import 'package:application/models/bingocard_model.dart';
import 'package:application/models/track_activity_model.dart';
import 'package:application/screens/admin/activity/activity_details_screen.dart';
import 'package:application/screens/admin/activity/add_activity_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ManageActivitiesScreen extends StatefulWidget {
  final BingoCardModel bingoCard;

  const ManageActivitiesScreen({Key? key, required this.bingoCard})
      : super(key: key);

  @override
  State<ManageActivitiesScreen> createState() => _ManageActivitiesScreenState();
}

class _ManageActivitiesScreenState extends State<ManageActivitiesScreen> {
  String? userId = FirebaseAuth.instance.currentUser?.uid;
  late ActivityController activityController;
  late TrackActivityController trackActivityController;
  late TrackBingoCardController trackBingoCardController;

  @override
  void initState() {
    super.initState();

    activityController =
        Provider.of<ActivityController>(context, listen: false);
    trackActivityController =
        Provider.of<TrackActivityController>(context, listen: false);
    trackBingoCardController =
        Provider.of<TrackBingoCardController>(context, listen: false);

    activityController.getAllActivities(widget.bingoCard.id!);
    trackActivityController.getMarkedActivities(userId!, widget.bingoCard.id!);
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
        child: Consumer2<ActivityController, TrackActivityController>(
          builder: (context, activityCtrl, trackCtrl, child) {
            if (activityCtrl.isLoading || trackCtrl.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (activityCtrl.errorMessage != null) {
              return Center(child: Text(activityCtrl.errorMessage!));
            }

            final int count = widget.bingoCard.category == "default"
                ? activityCtrl.activities.length
                : activityCtrl.activities.length + 1;

            return Column(
              children: [
                const SizedBox(height: 20),
                Expanded(
                  child: GridView.builder(
                    itemCount: count,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemBuilder: (context, index) {
                      if (widget.bingoCard.category == "default") {
                        ActivityModel activity = activityCtrl.activities[index];

                        bool isMarked = trackCtrl.todayMarkedActivities
                            .contains(activity.id);

                        return _buildActivityCard(
                          context,
                          icon: Icons.star,
                          title: activity.name ?? 'No Name',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ActivityDetailsScreen(
                                    activityId: activity.id!),
                              ),
                            );
                          },
                          image: activity.imageUrl ?? '',
                          isMarked: isMarked,
                          onMarkChanged: (bool? value) {
                            trackCtrl.toggleActivityMark(
                              TrackActivityModel(
                                userId: userId,
                                activityId: activity.id!,
                                bingoCardId: widget.bingoCard.id,
                                isTodayCompleted: value,
                                totalCompletes: 0,
                                createdAt: DateTime.now(),
                                updatedAt: DateTime.now(),
                              ),
                            );

                            trackBingoCardController
                                .getMarkedBingoCards(userId!);
                          },
                        );
                      } else {
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
                                  ),
                                ),
                              );
                            },
                            image: null,
                            isHideMark: true,
                            onMarkChanged: (_) {},
                          );
                        } else {
                          ActivityModel activity =
                              activityCtrl.activities[index - 1];

                          bool isMarked = trackCtrl.todayMarkedActivities
                              .contains(activity.id);

                          return _buildActivityCard(
                            context,
                            icon: Icons.star,
                            title: activity.name ?? 'No Name',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ActivityDetailsScreen(
                                      activityId: activity.id!),
                                ),
                              );
                            },
                            image: activity.imageUrl ?? '',
                            isMarked: isMarked,
                            onMarkChanged: (bool? value) {
                              trackCtrl.toggleActivityMark(
                                TrackActivityModel(
                                  userId: userId,
                                  activityId: activity.id!,
                                  bingoCardId: widget.bingoCard.id,
                                  isTodayCompleted: value,
                                  totalCompletes: 0,
                                  createdAt: DateTime.now(),
                                  updatedAt: DateTime.now(),
                                ),
                              );

                              trackBingoCardController
                                  .getMarkedBingoCards(userId!);
                            },
                          );
                        }
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
      required String? image,
      bool isHideMark = false,
      bool isMarked = false,
      required ValueChanged<bool?> onMarkChanged}) {
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
          image: image != null && image.isNotEmpty && image.contains("http")
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
            const SizedBox(height: 10),
            if (!isHideMark)
              Checkbox(
                value: isMarked,
                onChanged: onMarkChanged,
                activeColor: Theme.of(context).primaryColor,
              ),
          ],
        ),
      ),
    );
  }
}
