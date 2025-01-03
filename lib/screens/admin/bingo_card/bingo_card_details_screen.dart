import 'package:application/controllers/bingocard_controller.dart';
import 'package:application/screens/admin/activity/manage_activities_screen.dart';
import 'package:application/screens/admin/bingo_card/bingo_card_edit_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:application/models/bingocard_model.dart';
import 'package:provider/provider.dart';

class BingoCardDetailsScreen extends StatefulWidget {
  final BingoCardModel bingoCard;

  const BingoCardDetailsScreen({Key? key, required this.bingoCard})
      : super(key: key);

  @override
  State<BingoCardDetailsScreen> createState() => _BingoCardDetailsScreenState();
}

class _BingoCardDetailsScreenState extends State<BingoCardDetailsScreen> {
  late BingoCardController bingoCardController;
  String? userId = FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    super.initState();
    bingoCardController =
        Provider.of<BingoCardController>(context, listen: false);

    bingoCardController.getBingoCardById(widget.bingoCard.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bingo Card Details'),
        backgroundColor: Colors.transparent,
      ),
      body: Consumer<BingoCardController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.errorMessage != null) {
            return Center(child: Text(controller.errorMessage!));
          }

          final bingoCard = controller.bingoCard;

          if (bingoCard == null) {
            return const Center(child: Text('No data found.'));
          }

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                        image: bingoCard.imageUrl != null &&
                                bingoCard.imageUrl!.isNotEmpty &&
                                bingoCard.imageUrl!.contains("http")
                            ? NetworkImage(bingoCard.imageUrl!)
                            : const AssetImage('assets/images/default.jpg')
                                as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    bingoCard.title ?? 'No Title',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    bingoCard.description ?? 'No Description',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Icon(Icons.category, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Category: ${bingoCard.category ?? 'N/A'}',
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
                        'User ID: ${bingoCard.userId ?? 'N/A'}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      if (userId == bingoCard.userId)
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BingoCardEditScreen(
                                    bingoCard: bingoCard,
                                  ),
                                ),
                              );

                              if (result == true) {
                                bingoCardController
                                    .getBingoCardById(widget.bingoCard.id!);
                              }
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
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ManageActivitiesScreen(
                                          bingoCard: widget.bingoCard,
                                        )));
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: Theme.of(context).primaryColor,
                          ),
                          child: const Text(
                            'Activities',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
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
