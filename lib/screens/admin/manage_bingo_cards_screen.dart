import 'package:application/models/user_model.dart';
import 'package:application/models/bingocard_model.dart';
import 'package:application/screens/admin/add_bingo_card_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/bingocard_controller.dart';

class ManageBingoCardsScreen extends StatefulWidget {
  const ManageBingoCardsScreen({Key? key}) : super(key: key);

  @override
  State<ManageBingoCardsScreen> createState() => _ManageBingoCardsScreenState();
}

class _ManageBingoCardsScreenState extends State<ManageBingoCardsScreen> {
  late UserModel user;

  @override
  void initState() {
    super.initState();
    user = Provider.of<AuthController>(context, listen: false).currentUser!;
    Provider.of<BingoCardController>(context, listen: false).getAllBingoCards();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Bingo Cards'),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Consumer<BingoCardController>(
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
                    itemCount: controller.bingoCards.length + 1,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return _buildDashboardCard(
                          context,
                          icon: Icons.add,
                          title: 'Add',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const AddBingoCardScreen(),
                              ),
                            );
                          },
                          image: user.imageUrl,
                        );
                      } else {
                        BingoCardModel card =
                            controller.bingoCards[index - 1];
                        return _buildDashboardCard(
                          context,
                          icon: Icons.card_giftcard,
                          title: card.title ?? 'No Title',
                          onTap: () {},
                          image: card.imageUrl!.contains("http")
                              ? card.imageUrl
                              : null,
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

  Widget _buildDashboardCard(BuildContext context,
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
          image: image != null
              ? DecorationImage(
                  image: image.contains('http')
                      ? NetworkImage(image)
                      : AssetImage(image) as ImageProvider,
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.7),
                    BlendMode.darken,
                  ),
                )
              : null, // Hide image if `backgroundImage` is null
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
