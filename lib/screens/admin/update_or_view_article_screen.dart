import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/article_model.dart';
import '../../controllers/article_controller.dart';

class UpdateOrViewArticleScreen extends StatefulWidget {
  final ArticleModel article;

  const UpdateOrViewArticleScreen({
    Key? key,
    required this.article,
  }) : super(key: key);

  @override
  State<UpdateOrViewArticleScreen> createState() => _UpdateOrViewArticleScreenState();
}

class _UpdateOrViewArticleScreenState extends State<UpdateOrViewArticleScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController titleController;
  late TextEditingController contentController;
  late TextEditingController youtubeLinkController;  // New controller
  bool isBold = false;
  bool isItalic = false;
  bool isUnderline = false;
  TextAlign textAlignment = TextAlign.left;
  bool isLoading = false;

  late ArticleController articleController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.article.title);
    contentController = TextEditingController(text: widget.article.content);
    youtubeLinkController = TextEditingController(text: widget.article.youtubeLink);  // Initialize YouTube link controller
    articleController = Provider.of<ArticleController>(context, listen: false);
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    youtubeLinkController.dispose();  // Dispose YouTube link controller
    super.dispose();
  }

  Future<void> _updateArticle() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final updatedArticle = ArticleModel(
        id: widget.article.id,
        title: titleController.text,
        content: contentController.text,
        youtubeLink: youtubeLinkController.text,  // Pass the YouTube link
      );

      articleController.updateArticle(widget.article.id!, updatedArticle);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Article updated successfully!')),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating article: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> _deleteArticle() async {
    if (widget.article.id == null) {
      // Ensure the ID is valid
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid article ID')),
      );
      return;
    }

    // Show confirmation dialog before proceeding with deletion
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text('Do you really want to delete this article? This action cannot be undone.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );

    // If the user confirms, proceed with deletion
    if (shouldDelete ?? false) {
      try {
        setState(() => isLoading = true);
        print("Deleting article with ID: ${widget.article.id}"); // Debug log
        articleController.deleteArticle(widget.article.id!); // Ensure non-null id
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Article deleted successfully!')),
        );
        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting article: $e')),
        );
        print("Error during delete: $e"); // Debug log
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  Widget _buildFormatButton({
    required IconData icon,
    required bool isActive,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      icon: Icon(
        icon,
        color: isActive ? Theme.of(context).primaryColor : Colors.grey,
      ),
      onPressed: onPressed,
    );
  }

  Widget _buildAlignmentButton({
    required IconData icon,
    required TextAlign alignment,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      icon: Icon(
        icon,
        color: textAlignment == alignment
            ? Theme.of(context).primaryColor
            : Colors.grey,
      ),
      onPressed: onPressed,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Article'),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: isLoading ? null : _deleteArticle,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
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

              // YouTube Link Field
              TextFormField(
                controller: youtubeLinkController,
                decoration: const InputDecoration(labelText: 'YouTube Link'),
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: Colors.white),
                validator: (value) {
                  if (value != null && value.isNotEmpty && !Uri.tryParse(value)!.hasScheme) {
                    return 'Please enter a valid URL';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Formatting toolbar
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade800),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFormatButton(
                        icon: Icons.format_bold,
                        isActive: isBold,
                        onPressed: () => setState(() => isBold = !isBold),
                      ),
                      _buildFormatButton(
                        icon: Icons.format_italic,
                        isActive: isItalic,
                        onPressed: () => setState(() => isItalic = !isItalic),
                      ),
                      _buildFormatButton(
                        icon: Icons.format_underline,
                        isActive: isUnderline,
                        onPressed: () => setState(() => isUnderline = !isUnderline),
                      ),
                      const VerticalDivider(),
                      _buildAlignmentButton(
                        icon: Icons.format_align_left,
                        alignment: TextAlign.left,
                        onPressed: () => setState(() => textAlignment = TextAlign.left),
                      ),
                      _buildAlignmentButton(
                        icon: Icons.format_align_center,
                        alignment: TextAlign.center,
                        onPressed: () => setState(() => textAlignment = TextAlign.center),
                      ),
                      _buildAlignmentButton(
                        icon: Icons.format_align_right,
                        alignment: TextAlign.right,
                        onPressed: () => setState(() => textAlignment = TextAlign.right),
                      ),
                      const VerticalDivider(),
                      _buildFormatButton(
                        icon: Icons.format_list_bulleted,
                        isActive: false,
                        onPressed: () {
                          final text = contentController.text;
                          final selection = contentController.selection;
                          final newText = text.replaceRange(
                            selection.start,
                            selection.start,
                            '\n• ',
                          );
                          contentController.value = TextEditingValue(
                            text: newText,
                            selection: TextSelection.collapsed(
                              offset: selection.start + 3,
                            ),
                          );
                        },
                      ),
                      _buildFormatButton(
                        icon: Icons.format_list_numbered,
                        isActive: false,
                        onPressed: () {
                          final text = contentController.text;
                          final selection = contentController.selection;
                          final newText = text.replaceRange(
                            selection.start,
                            selection.start,
                            '\n1. ',
                          );
                          contentController.value = TextEditingValue(
                            text: newText,
                            selection: TextSelection.collapsed(
                              offset: selection.start + 4,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Content editor
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade800),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextFormField(
                    controller: contentController,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(16),
                      border: InputBorder.none,
                      hintText: 'Start writing your article...',
                    ),
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Colors.white,
                      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                      fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
                      decoration: isUnderline ? TextDecoration.underline : null,
                    ),
                    textAlign: textAlignment,
                    maxLines: null,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter content';
                      }
                      return null;
                    },
                  ),
                ),
              ),

              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _updateArticle,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : const Text(
                    'Update Article',
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
