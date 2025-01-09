import 'package:application/controllers/auth_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:application/controllers/activity_controller.dart';
import 'package:application/models/activity_model.dart';

import '../../../models/bingocard_model.dart';
import '../../../models/user_model.dart';

class AddActivityScreen extends StatefulWidget {
  final BingoCardModel bingoCard;

  const AddActivityScreen({Key? key, required this.bingoCard})
      : super(key: key);

  @override
  State<AddActivityScreen> createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends State<AddActivityScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  String _status = 'active';

  late AuthController authController;
  late UserModel user;

  @override
  void initState() {
    authController = Provider.of<AuthController>(context, listen: false);
    user = authController.currentUser!;
    if (user == null) {
      authController.getCurrentUser();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final activityController = Provider.of<ActivityController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Activity'),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Activity Name'),
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter activity name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(labelText: 'Image URL'),
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter image URL';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField(
                value: _status,
                items: const [
                  DropdownMenuItem(value: 'active', child: Text('Active')),
                  DropdownMenuItem(value: 'inactive', child: Text('Inactive')),
                ],
                onChanged: (value) {
                  setState(() {
                    _status = value.toString();
                  });
                },
                decoration: const InputDecoration(labelText: 'Status'),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      String? userId = FirebaseAuth.instance.currentUser?.uid;
                      final newActivity = ActivityModel(
                          name: _nameController.text.trim(),
                          imageUrl: _imageUrlController.text.trim(),
                          status: _status,
                          category: user.role == "admin" ? "default" : "custom",
                          bingoCardId: widget.bingoCard.id,
                          userId: userId);
                      await activityController.addActivity(newActivity);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Activity Added.'),
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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
