import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher package
import 'package:video_player/video_player.dart'; // Import video_player package
import '../../models/article_model.dart';
import '../../controllers/article_controller.dart';
import '../../controllers/auth_controller.dart';
import './add_article_screen.dart';
import './update_or_view_article_screen.dart';

class ManageArticlesScreen extends StatefulWidget {
  const ManageArticlesScreen({Key? key}) : super(key: key);

  @override
  State<ManageArticlesScreen> createState() => _ManageArticlesScreenState();
}

class _ManageArticlesScreenState extends State<ManageArticlesScreen> {
  late VideoPlayerController _controller;
  bool _isVideoPlaying = false;

  @override
  void initState() {
    super.initState();
    Provider.of<ArticleController>(context, listen: false).getAllArticles();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _playVideo(String youtubeLink) async {
    final Uri url = Uri.parse(youtubeLink); // Parse the URL

    try {
      // Check if it's a YouTube URL
      if (youtubeLink.contains("youtube.com") || youtubeLink.contains("youtu.be")) {
        // Construct YouTube intent (Android specific)
        final Uri intentUrl = Uri.parse('vnd.youtube:${url.queryParameters['v']}');

        // Try to launch in YouTube external app
        if (await canLaunchUrl(intentUrl)) {
          await launchUrl(intentUrl, mode: LaunchMode.externalApplication);
        } else {
          // Fallback to regular browser URL
          await launchUrl(url, mode: LaunchMode.externalApplication);
        }
      } else {
        // If it's not a YouTube URL, launch the regular URL
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        } else {
          print('Could not launch the video link.');
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
                // Add Article Button at the top (No video section for this)
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
                      if (mounted) {
                        Provider.of<ArticleController>(context, listen: false).getAllArticles();
                      }
                    }
                  },
                  isAddArticle: true, // Flag for Add Article
                ),
                const SizedBox(height: 20),
                // List of Articles
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

                            // Refresh the articles list when returning from update screen
                            if (result == true) {
                              if (mounted) {
                                Provider.of<ArticleController>(context, listen: false).getAllArticles();
                              }
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
        String? youtubeLink, // The YouTube video link for the article
        bool isAddArticle = false, // Flag to check if it's the add article card
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
              Colors.grey[850]!, // Dark Gray
              Colors.grey[900]!, // Black
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
            // Video section - only for article cards, not for Add Article button
            if (!isAddArticle && youtubeLink != null && youtubeLink.isNotEmpty)
              Container(
                height: 200, // Adjust height of the video placeholder
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black12, // Placeholder for the video section
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
                            _playVideo(youtubeLink); // Pass the correct YouTube link here
                          }
                        },
                      ),
                    ),
                  ],
                ),
              )
            else if (!isAddArticle)
              Container(
                height: 200, // Placeholder for no video
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black, // Placeholder black background
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
              onTap: onTap, // Tapping the card navigates to the article screen
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
