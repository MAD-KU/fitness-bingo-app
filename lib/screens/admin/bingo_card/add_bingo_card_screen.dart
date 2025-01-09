import 'package:application/controllers/bingocard_controller.dart';
import 'package:application/models/bingocard_model.dart';
import 'package:application/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/auth_controller.dart';

class AddBingoCardScreen extends StatefulWidget {
  const AddBingoCardScreen({Key? key}) : super(key: key);

  @override
  State<AddBingoCardScreen> createState() => _AddBingoCardScreenState();
}

class _AddBingoCardScreenState extends State<AddBingoCardScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();
  String category = 'Easy';
  var isLoading = false;

  late AuthController authController;
  late BingoCardController bingoCardController;
  late UserModel user;

  @override
  void initState() {
    authController = Provider.of<AuthController>(context, listen: false);
    bingoCardController =
        Provider.of<BingoCardController>(context, listen: false);
    user = authController.currentUser!;
    super.initState();
  }

  void _saveBingoCard() {
    if (_formKey.currentState!.validate()) {
      String? userId = FirebaseAuth.instance.currentUser?.uid;
      String? title = titleController.text;
      String? description = descriptionController.text;
      String? imageUrl = imageUrlController.text;
      try {
        bingoCardController.addBingoCard(BingoCardModel(
            title: title,
            description: description,
            userId: userId,
            category: user.role == "admin" ? "default" : "custom",
            imageUrl: imageUrl));

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Bingo Card Saved!'),
        ));
        Navigator.pop(context);
      } catch (e) {
        print(e.toString());
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Something wrong!'),
        ));
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Bingo Card'),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // DropdownButtonFormField(
              //   value: category,
              //   items: ['Easy', 'Medium', 'Hard']
              //       .map((label) => DropdownMenuItem(
              //             value: label,
              //             child: Text(label),
              //           ))
              //       .toList(),
              //   onChanged: (value) {
              //     setState(() {
              //       category = value.toString();
              //     });
              //   },
              //   decoration: const InputDecoration(labelText: 'Category'),
              // ),
              // const SizedBox(height: 20),
              TextFormField(
                controller: imageUrlController,
                decoration: const InputDecoration(labelText: 'Image URL'),
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an image URL';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveBingoCard,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  child: const Text(
                    'Save Bingo Card',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
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
