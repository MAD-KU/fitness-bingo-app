import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/store_controller.dart';
import '../../models/store_model.dart';
import 'store_item_detail_screen.dart';

class StoreItemCard extends StatelessWidget {
  final StoreModel item;

  const StoreItemCard({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StoreItemDetailScreen(item: item),
            ),
          );
        },
        child: SizedBox(
          height: 280, // Fixed height to prevent overflow
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                  ),
                  child: Stack(
                    children: [
                      Image.network(
                        item.imageUrl ?? 'https://via.placeholder.com/150',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.error,
                          color: theme.primaryColor,
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: IconButton(
                          icon: const Icon(
                            Icons.shopping_cart,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Provider.of<StoreController>(context, listen: false)
                                .launchAmazonUrl(item.affiliateUrl);
                          },
                          style: IconButton.styleFrom(
                            backgroundColor: theme.primaryColor.withOpacity(0.8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Product Details
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Name
                      Text(
                        item.name ?? 'No name',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 2),

                      // Brand
                      if (item.brand != null)
                        Text(
                          item.brand!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.hintColor,
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),

                      const SizedBox(height: 2),

                      // Price
                      Text(
                        '\$${item.price?.toStringAsFixed(2) ?? '0.00'}',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: theme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const Spacer(),

                      // Rating and Prime Badge
                      Row(
                        children: [
                          if (item.rating != null) ...[
                            Icon(
                              Icons.star,
                              size: 16,
                              color: Colors.amber,
                            ),
                            Text(
                              ' ${item.rating}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: 12,
                              ),
                            ),
                            const Spacer(),
                          ],
                          if (item.primeEligible == 'Yes')
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: theme.primaryColor,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'Prime',
                                style: TextStyle(
                                  color: theme.scaffoldBackgroundColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
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