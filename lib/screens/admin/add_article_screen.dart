import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/article_controller.dart';
import '../../models/article_model.dart';

class AddArticleScreen extends StatefulWidget {
  const AddArticleScreen({Key? key}) : super(key: key);

  @override
  State<AddArticleScreen> createState() => _AddArticleScreenState();
}

class _AddArticleScreenState extends State<AddArticleScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController youtubeLinkController = TextEditingController(); // Controller for YouTube link
  bool isBold = false;
  bool isItalic = false;
  bool isUnderline = false;
  TextAlign textAlignment = TextAlign.left;
  var isLoading = false;

  late ArticleController articleController;

  @override
  void initState() {
    super.initState();
    articleController = Provider.of<ArticleController>(context, listen: false);
  }

  void _saveArticle() {
    if (_formKey.currentState!.validate()) {
      String title = titleController.text;
      String content = contentController.text;
      String youtubeLink = youtubeLinkController.text; // Get YouTube link

      try {
        articleController.addArticle(ArticleModel(
          title: title,
          content: content,
          youtubeLink: youtubeLink, // Save YouTube link
        ));

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Article Saved!')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Something went wrong!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Article'),
        backgroundColor: Colors.transparent,
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

              // YouTube link input field
              TextFormField(
                controller: youtubeLinkController, // Controller for YouTube link
                decoration: const InputDecoration(labelText: 'YouTube Link'),
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: Colors.white),
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final youtubeRegex = RegExp(r'^(https?\:\/\/)?(www\.)?(youtube|youtu|youtube-nocookie)\.(com|be)\/.+$');
                    if (!youtubeRegex.hasMatch(value)) {
                      return 'Please enter a valid YouTube link';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

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
                  onPressed: _saveArticle,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  child: const Text(
                    'Save Article',
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
