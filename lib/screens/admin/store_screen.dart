// admin_store_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/store_controller.dart';
import '../../models/store_model.dart';
import '../admin/store_item_card.dart';

class AdminStoreScreen extends StatefulWidget {
  const AdminStoreScreen({Key? key}) : super(key: key);

  @override
  State<AdminStoreScreen> createState() => _AdminStoreScreenState();
}

class _AdminStoreScreenState extends State<AdminStoreScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _imageUrlController;
  late TextEditingController _brandController;
  late TextEditingController _ratingController;
  String _selectedCategory = 'Cardio Equipment';
  bool _isAvailable = true;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    Provider.of<StoreController>(context, listen: false).getAllStoreItems();
  }

  void _initializeControllers() {
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _priceController = TextEditingController();
    _imageUrlController = TextEditingController();
    _brandController = TextEditingController();
    _ratingController = TextEditingController();
  }

  void _resetControllers() {
    _nameController.clear();
    _descriptionController.clear();
    _priceController.clear();
    _imageUrlController.clear();
    _brandController.clear();
    _ratingController.clear();
    _selectedCategory = 'Cardio Equipment';
    _isAvailable = true;
  }

  void _showStoreDialog({StoreModel? item}) {
    if (item != null) {
      _nameController.text = item.name ?? '';
      _descriptionController.text = item.description ?? '';
      _priceController.text = item.price?.toString() ?? '';
      _imageUrlController.text = item.imageUrl ?? '';
      _brandController.text = item.brand ?? '';
      _ratingController.text = item.rating?.toString() ?? '';
      _selectedCategory = item.category ?? 'Cardio Equipment';
      _isAvailable = item.isAvailable;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          item == null ? 'Add New Store Item' : 'Edit Store Item',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        content: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _nameController,
                    style: const TextStyle(color: Colors.white), // Ensure text is white
                    decoration: InputDecoration(
                      labelText: 'Name',
                      labelStyle: TextStyle(color: Colors.greenAccent[700]),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.greenAccent, width: 2),
                      ),
                      contentPadding: EdgeInsets.all(16),
                    ),
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Required' : null,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _descriptionController,
                    style: const TextStyle(color: Colors.white), // Ensure text is white
                    decoration: InputDecoration(
                      labelText: 'Description',
                      labelStyle: TextStyle(color: Colors.greenAccent[700]),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.greenAccent, width: 2),
                      ),
                      contentPadding: EdgeInsets.all(16),
                    ),
                    maxLines: 3,
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Required' : null,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _priceController,
                    style: const TextStyle(color: Colors.white), // Ensure text is white
                    decoration: InputDecoration(
                      labelText: 'Price',
                      labelStyle: TextStyle(color: Colors.greenAccent[700]),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.greenAccent, width: 2),
                      ),
                      contentPadding: EdgeInsets.all(16),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Required' : null,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _imageUrlController,
                    style: const TextStyle(color: Colors.white), // Ensure text is white
                    decoration: InputDecoration(
                      labelText: 'Image URL',
                      labelStyle: TextStyle(color: Colors.greenAccent[700]),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.greenAccent, width: 2),
                      ),
                      contentPadding: EdgeInsets.all(16),
                    ),
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Required' : null,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _brandController,
                    style: const TextStyle(color: Colors.white), // Ensure text is white
                    decoration: InputDecoration(
                      labelText: 'Brand',
                      labelStyle: TextStyle(color: Colors.greenAccent[700]),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.greenAccent, width: 2),
                      ),
                      contentPadding: EdgeInsets.all(16),
                    ),
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Required' : null,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _ratingController,
                    style: const TextStyle(color: Colors.white), // Ensure text is white
                    decoration: InputDecoration(
                      labelText: 'Rating (0-5)',
                      labelStyle: TextStyle(color: Colors.greenAccent[700]),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.greenAccent, width: 2),
                      ),
                      contentPadding: EdgeInsets.all(16),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) return null;
                      final rating = double.tryParse(value);
                      if (rating == null || rating < 0 || rating > 5) {
                        return 'Rating must be between 0 and 5';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    style: const TextStyle(color: Colors.white), // Ensure text is white
                    decoration: InputDecoration(
                      labelText: 'Category',
                      labelStyle: TextStyle(color: Colors.greenAccent[700]),
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(16),
                    ),
                    items: Provider.of<StoreController>(context, listen: false)
                        .categories
                        .where((category) => category != 'All')
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        _selectedCategory = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: Text(
                      'Available',
                      style: TextStyle(color: Colors.greenAccent[700]),
                    ),
                    value: _isAvailable,
                    onChanged: (bool value) {
                      setState(() {
                        _isAvailable = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _resetControllers();
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              'Cancel',
              style: TextStyle(fontSize: 16),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState?.validate() ?? false) {
                final storeItem = StoreModel(
                  id: item?.id,
                  name: _nameController.text,
                  description: _descriptionController.text,
                  price: double.parse(_priceController.text),
                  imageUrl: _imageUrlController.text,
                  category: _selectedCategory,
                  brand: _brandController.text,
                  rating: double.tryParse(_ratingController.text),
                  isAvailable: _isAvailable,
                  userId: 'admin',
                );

                try {
                  if (item == null) {
                    await Provider.of<StoreController>(context, listen: false)
                        .addStoreItem(storeItem);
                  } else {
                    await Provider.of<StoreController>(context, listen: false)
                        .updateStoreItem(storeItem);
                  }
                  _resetControllers();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        item == null
                            ? 'Store item added successfully!'
                            : 'Store item updated successfully!',
                      ),
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightGreenAccent,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              minimumSize: Size(120, 45),
            ),
            child: Text(
              item == null ? 'Add Item' : 'Update Item',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(StoreModel item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Store Item'),
        content: Text('Are you sure you want to delete "${item.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await Provider.of<StoreController>(context, listen: false)
                    .deleteStoreItem(item.id!);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Store item deleted successfully!')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error deleting item: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Store Management',
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Consumer<StoreController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.errorMessage != null) {
            return Center(child: Text(controller.errorMessage!));
          }

          return Column(
            children: [
              Container(
                height: 70,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                          style: TextStyle(fontSize: 14),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        onSelected: (_) =>
                            controller.setSelectedCategory(category),
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: controller.storeItems.length,
                  itemBuilder: (context, index) {
                    final item = controller.storeItems[index];
                    return Card(
                      elevation: 4,
                      child: Stack(
                        children: [
                          StoreItemCard(item: item),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: theme.primaryColor,
                                  radius: 20,
                                  child: IconButton(
                                    icon: const Icon(Icons.edit,
                                        color: Colors.white),
                                    onPressed: () =>
                                        _showStoreDialog(item: item),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                CircleAvatar(
                                  backgroundColor: Colors.red,
                                  radius: 20,
                                  child: IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.white),
                                    onPressed: () =>
                                        _showDeleteConfirmation(item),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showStoreDialog(),
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _imageUrlController.dispose();
    _brandController.dispose();
    _ratingController.dispose();
    super.dispose();
  }
}
