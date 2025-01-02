import 'package:application/screens/user/activity/view_article_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../models/article_model.dart';
import '../../../controllers/article_controller.dart';

class ArticlesScreen extends StatefulWidget {
  const ArticlesScreen({Key? key}) : super(key: key);

  @override
  State<ArticlesScreen> createState() => _ArticlesScreenState();
}

class _ArticlesScreenState extends State<ArticlesScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch all articles when screen initializes
    Provider.of<ArticleController>(context, listen: false).getAllArticles();
  }

  void _playVideo(String youtubeLink) async {
    final Uri url = Uri.parse(youtubeLink);

    try {
      if (youtubeLink.contains("youtube.com") || youtubeLink.contains("youtu.be")) {
        final Uri intentUrl = Uri.parse('vnd.youtube:${url.queryParameters['v']}');
        if (await canLaunchUrl(intentUrl)) {
          await launchUrl(intentUrl, mode: LaunchMode.externalApplication);
        } else {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        }
      } else {
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        }
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Articles'),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Consumer<ArticleController>(
          builder: (context, controller, child) {
            if (controller.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.errorMessage != null) {
              return Center(child: Text(controller.errorMessage!));
            }

            return ListView.builder(
              itemCount: controller.articles.length,
              itemBuilder: (context, index) {
                ArticleModel article = controller.articles[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: _buildArticleCard(
                    context,
                    article: article,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildArticleCard(BuildContext context, {required ArticleModel article}) {
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViewArticleScreen(
              article: article,
            ),
          ),
        );

        if (result == true) {
          Provider.of<ArticleController>(context, listen: false).getAllArticles();
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black54,
              Colors.grey[900]!,
            ],
            stops: const [0.3, 1.0],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
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
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.youtubeLink != null && article.youtubeLink!.isNotEmpty)
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.network(
                        'https://img.youtube.com/vi/${Uri.parse(article.youtubeLink!).pathSegments.last}/0.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Center(
                      child: IconButton(
                        icon: Icon(
                          Icons.play_circle_fill,
                          size: 50,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: () {
                          if (article.youtubeLink!.isNotEmpty) {
                            _playVideo(article.youtubeLink!);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              )
            else
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    'No Video',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.article,
                  size: 24,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    article.title ?? 'No Title',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
