import 'package:flutter/material.dart';
import '../../models/store_model.dart';

class StoreItemDetailScreen extends StatelessWidget {
  final StoreModel item;

  const StoreItemDetailScreen({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Product Details',
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.grey[200],
              ),
              child: Image.network(
                item.imageUrl ?? '',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Center(
                  child: Icon(Icons.error_outline, size: 50),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name and Brand
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.name ?? 'N/A',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: item.isAvailable
                              ? Colors.green.withOpacity(0.1)
                              : Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          item.isAvailable ? 'In Stock' : 'Out of Stock',
                          style: TextStyle(
                            color:
                            item.isAvailable ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Brand: ${item.brand ?? 'N/A'}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Price
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '\$${item.price?.toStringAsFixed(2) ?? 'N/A'}',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: theme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Rating
                  if (item.rating != null) ...[
                    Row(
                      children: [
                        ...List.generate(5, (index) {
                          return Icon(
                            index < (item.rating ?? 0).floor()
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.amber,
                            size: 24,
                          );
                        }),
                        const SizedBox(width: 8),
                        Text(
                          '${item.rating}',
                          style: theme.textTheme.bodyLarge,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Category
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Category: ${item.category ?? 'N/A'}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Description
                  Text(
                    'Description',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.description ?? 'No description available',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}