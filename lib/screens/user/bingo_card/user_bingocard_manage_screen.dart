import 'package:application/controllers/bingocard_controller.dart';
import 'package:application/models/bingocard_model.dart';
import 'package:application/screens/admin/bingo_card/add_bingo_card_screen.dart';
import 'package:application/screens/admin/bingo_card/bingo_card_details_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/auth_controller.dart';
import '../../../controllers/track_bingocard_controller.dart';
import '../../../models/track_bingocard_model.dart';
import '../../../models/user_model.dart';

class UserBingoCardsScreen extends StatefulWidget {
  const UserBingoCardsScreen({Key? key}) : super(key: key);

  @override
  State<UserBingoCardsScreen> createState() => _UserBingoCardsScreenState();
}

class _UserBingoCardsScreenState extends State<UserBingoCardsScreen> {
  late BingoCardController bingoCardController;
  late TrackBingoCardController trackBingoCardController;
  late UserModel user;
  String? userId = FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    super.initState();
    bingoCardController =
        Provider.of<BingoCardController>(context, listen: false);
    trackBingoCardController =
        Provider.of<TrackBingoCardController>(context, listen: false);
    bingoCardController.getAllBingoCardsForUser(userId!);
    trackBingoCardController.getMarkedBingoCards(userId!);
    user = Provider.of<AuthController>(context, listen: false).currentUser!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bingo Cards'),
        backgroundColor: Colors.transparent,
      ),
      body: Consumer2<BingoCardController, TrackBingoCardController>(
        builder: (context, controller, trackCtrl, child) {
          if (controller.isLoading || trackCtrl.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.errorMessage != null) {
            return Center(child: Text(controller.errorMessage!));
          }

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: GridView.builder(
              itemCount: controller.bingoCards.length + 1,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemBuilder: (context, index) {
                if (index == controller.bingoCards.length) {
                  return _buildDashboardCard(
                    context,
                    icon: Icons.add,
                    title: 'Add',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddBingoCardScreen(),
                        ),
                      );
                    },
                    image: user.imageUrl,
                    isHideMark: true,
                    onMarkChanged: (bool? value) {},
                  );
                } else {
                  BingoCardModel card = controller.bingoCards[index];

                  bool isMarked =
                      trackCtrl.todayMarkedBingoCards.contains(card.id);

                  return _buildDashboardCard(
                    context,
                    icon: Icons.card_giftcard,
                    title: card.title ?? 'No Title',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BingoCardDetailsScreen(
                            bingoCard: card,
                          ),
                        ),
                      );
                    },
                    image:
                        card.imageUrl!.contains("http") ? card.imageUrl : null,
                    isMarked: isMarked,
                    isHideMark: !isMarked,
                    onMarkChanged: (bool? value) {
                      // trackBingoCardController.toggleBingoCardMark(
                      //   TrackBingoCardModel(
                      //     userId: userId,
                      //     bingoCardId: card.id!,
                      //     isTodayCompleted: value,
                      //     totalCompletes: 0,
                      //     createdAt: DateTime.now(),
                      //     updatedAt: DateTime.now(),
                      //   ),
                      // );
                    },
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildDashboardCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required String? image,
    bool isHideMark = false,
    bool isMarked = false,
    required ValueChanged<bool?> onMarkChanged,
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
