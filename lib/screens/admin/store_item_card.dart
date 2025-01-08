import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
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
          width: double.infinity,
          height: 211.1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              SizedBox(
                height: 128, // Adjusted height
                width: double.infinity,
                child: Stack(
                  children: [
                    Image.network(
                      item.imageUrl ?? 'https://via.placeholder.com/150',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.error,
                        color: theme.primaryColor,
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        icon: const Icon(
                          Icons.shopping_cart,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () async {
                          final Uri url = Uri.parse(item.affiliateUrl!);

                          try {
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url,
                                  mode: LaunchMode.externalApplication);
                            }
                          } catch (e) {
                            print('Error: $e');
                          }
                        },
                        style: IconButton.styleFrom(
                          backgroundColor: theme.primaryColor.withOpacity(0.8),
                          padding: const EdgeInsets.all(6),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Product Details
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Name and Price Row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              item.name ?? 'No name',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '\$${item.price?.toStringAsFixed(2) ?? '0.00'}',
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: theme.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 2),

                      // Rating and Prime Badge Row
                      Row(
                        children: [
                          if (item.rating != null) ...[
                            const Icon(
                              Icons.star,
                              size: 12,
                              color: Colors.amber,
                            ),
                            Text(
                              ' ${item.rating}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontSize: 10,
                              ),
                            ),
                            const Spacer(),
                          ],
                          if (item.primeEligible == 'Yes')
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 1,
                              ),
                              decoration: BoxDecoration(
                                color: theme.primaryColor,
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: Text(
                                'Prime',
                                style: TextStyle(
                                  color: theme.scaffoldBackgroundColor,
                                  fontSize: 8,
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
