import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:application/models/activity_model.dart';
import 'package:application/controllers/activity_controller.dart';

class ActivityEditScreen extends StatefulWidget {
  final String activityId;

  const ActivityEditScreen({Key? key, required this.activityId})
      : super(key: key);

  @override
  State<ActivityEditScreen> createState() => _ActivityEditScreenState();
}

class _ActivityEditScreenState extends State<ActivityEditScreen> {
  late ActivityController activityController;
  final _formKey = GlobalKey<FormState>();

  String? name;
  String? imageUrl;
  String? status;
  String? category;

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
        title: const Text('Edit Activity'),
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

          name = activity.name;
          imageUrl = activity.imageUrl;
          status = activity.status;
          category = activity.category;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    initialValue: name,
                    decoration: const InputDecoration(labelText: 'Name'),
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: Colors.white),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Enter name' : null,
                    onChanged: (value) => name = value,
                  ),
                  const SizedBox(height: 20),

                  TextFormField(
                    initialValue: imageUrl,
                    decoration: const InputDecoration(labelText: 'Image URL'),
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: Colors.white),
                    onChanged: (value) => imageUrl = value,
                  ),
                  const SizedBox(height: 20),

                  DropdownButtonFormField(
                    value: status,
                    items: ['active', 'inactive']
                        .map((status) => DropdownMenuItem(
                              value: status,
                              child: Text(status.toUpperCase()),
                            ))
                        .toList(),
                    onChanged: (value) => status = value.toString(),
                    decoration: const InputDecoration(labelText: 'Status'),
                  ),
                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final updatedActivity = ActivityModel(
                            id: activity.id,
                            name: name,
                            imageUrl: imageUrl,
                            status: status,
                            category: category,
                            userId: activity.userId,
                            bingoCardId: activity.bingoCardId,
                          );
                          await activityController.updateActivity(
                              activity.id!, updatedActivity);
                          activityController.getActivityById(activity.id!);
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text('Activity Updated.'),
                          ));
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                      child: const Text(
                        'Save',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
