import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/store_controller.dart';
import '../../models/store_model.dart';
import '../admin/store_item_card.dart';

class UserStoreScreen extends StatefulWidget {
  const UserStoreScreen({Key? key}) : super(key: key);

  @override
  State<UserStoreScreen> createState() => _UserStoreScreenState();
}

class _UserStoreScreenState extends State<UserStoreScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<StoreController>(context, listen: false).getAllStoreItems();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Fitness Store',
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: theme.primaryColor),
            onPressed: () {
              // Implement search functionality if needed
            },
          ),
        ],
      ),
      body: Consumer<StoreController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.errorMessage != null) {
            return Center(child: Text(controller.errorMessage!));
          }

          // Filter out unavailable items for users
          final availableItems = controller.storeItems
              .where((item) => item.isAvailable)
              .toList();

          return Column(
            children: [
              // Category Filter
              Container(
                height: 70,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.categories.length,
                  itemBuilder: (context, index) {
                    final category = controller.categories[index];
                    final isSelected = controller.selectedCategory == category;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: FilterChip(
                        selected: isSelected,
                        label: Text(
                          category,
                          style: TextStyle(
                            fontSize: 14,
                            color: isSelected ? Colors.white : theme.textTheme.bodyMedium?.color,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        backgroundColor: theme.cardColor,
                        selectedColor: theme.primaryColor,
                        onSelected: (_) => controller.setSelectedCategory(category),
                      ),
                    );
                  },
                ),
              ),

              // Store Items Grid
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: availableItems.length,
                  itemBuilder: (context, index) {
                    final item = availableItems[index];
                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: StoreItemCard(item: item),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}