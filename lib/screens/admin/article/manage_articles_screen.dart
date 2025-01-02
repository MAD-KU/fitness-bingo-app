import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../models/article_model.dart';
import '../../../controllers/article_controller.dart';
import '../../../controllers/auth_controller.dart';
import 'add_article_screen.dart';
import './update_or_view_article_screen.dart';

class ManageArticlesScreen extends StatefulWidget {
  const ManageArticlesScreen({Key? key}) : super(key: key);

  @override
  State<ManageArticlesScreen> createState() => _ManageArticlesScreenState();
}

class _ManageArticlesScreenState extends State<ManageArticlesScreen> {
  bool _isVideoPlaying = false;

  @override
  void initState() {
    super.initState();
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
        title: const Text('Manage Articles'),
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

            return Column(
              children: [
                _buildDashboardCard(
                  context,
                  icon: Icons.add,
                  title: 'Add Article',
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddArticleScreen(),
                      ),
                    );

                    // Refresh the articles list when returning from add screen
                    if (result == true) {
                      Provider.of<ArticleController>(context, listen: false).getAllArticles();
                    }
                  },
                  isAddArticle: true,
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: controller.articles.length,
                    itemBuilder: (context, index) {
                      ArticleModel article = controller.articles[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: _buildDashboardCard(
                          context,
                          icon: Icons.article,
                          title: article.title ?? 'No Title',
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpdateOrViewArticleScreen(
                                  article: article,
                                ),
                              ),
                            );

                            if (result == true) {
                              Provider.of<ArticleController>(context, listen: false).getAllArticles();
                            }
                          },
                          youtubeLink: article.youtubeLink,
                        ),
                      );
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

  Widget _buildDashboardCard(
      BuildContext context, {
        required IconData icon,
        required String title,
        required VoidCallback onTap,
        String? youtubeLink,
        bool isAddArticle = false,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: !isAddArticle
              ? LinearGradient(
            colors: [
              Colors.black54!,
              Colors.grey[900]!,
            ],
            stops: const [0.3, 1.0],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
              : RadialGradient(
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.8),
              Theme.of(context).primaryColor.withOpacity(0.5),
              Theme.of(context).cardColor.withOpacity(0.3),
            ],
            stops: const [0.2, 0.5, 1.0],
            center: Alignment.centerRight,
            radius: 1.5,
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
            if (!isAddArticle && youtubeLink != null && youtubeLink.isNotEmpty)
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
                        'https://img.youtube.com/vi/${Uri.parse(youtubeLink).pathSegments.last}/0.jpg',
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
                          if (youtubeLink.isNotEmpty) {
                            _playVideo(youtubeLink);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              )
            else if (!isAddArticle)
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
            GestureDetector(
              onTap: onTap,
              child: Row(
                children: [
                  Icon(
                    icon,
                    size: 24,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w700,
                      ),
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
