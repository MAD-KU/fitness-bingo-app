import 'package:application/controllers/bingocard_controller.dart';
import 'package:flutter/material.dart';
import 'package:application/models/bingocard_model.dart';
import 'package:provider/provider.dart';

class BingoCardEditScreen extends StatefulWidget {
  final BingoCardModel bingoCard;

  const BingoCardEditScreen({Key? key, required this.bingoCard})
      : super(key: key);

  @override
  State<BingoCardEditScreen> createState() => _BingoCardEditScreenState();
}

class _BingoCardEditScreenState extends State<BingoCardEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController imageUrlController;
  late String selectedCategory;

  late BingoCardController bingoCardController;

  @override
  void initState() {
    titleController = TextEditingController(text: widget.bingoCard.title);
    descriptionController =
        TextEditingController(text: widget.bingoCard.description);
    imageUrlController = TextEditingController(text: widget.bingoCard.imageUrl);
    bingoCardController =
        Provider.of<BingoCardController>(context, listen: false);
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Bingo Card'),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title Input
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

                // Description Input
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

                // Category Dropdown
                // DropdownButtonFormField<String>(
                //   value: selectedCategory,
                //   decoration: const InputDecoration(
                //     labelText: 'Category',
                //     border: OutlineInputBorder(),
                //   ),
                //   items: ['Easy', 'Medium', 'Hard']
                //       .map((category) => DropdownMenuItem(
                //             value: category,
                //             child: Text(category),
                //           ))
                //       .toList(),
                //   onChanged: (value) {
                //     setState(() => selectedCategory = value!);
                //   },
                // ),
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

                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        bingoCardController.updateBingoCard(
                            widget.bingoCard.id!,
                            BingoCardModel(
                                title: titleController.text,
                                description: descriptionController.text,
                                imageUrl: imageUrlController.text,
                                userId: widget.bingoCard.userId,
                                category: widget.bingoCard.category));

                        bingoCardController
                            .getBingoCardById(widget.bingoCard.id!);
                        bingoCardController.getAllBingoCards();
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    child: const Text(
                      'Save',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
