import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../models/article_model.dart';

class ViewArticleScreen extends StatelessWidget {
  final ArticleModel article;

  const ViewArticleScreen({Key? key, required this.article}) : super(key: key);

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
        title: Text(article.title ?? 'Article'),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
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
            const SizedBox(height: 20),
            Text(
              article.title ?? 'No Title',
              style: Theme.of(context).textTheme.headline5?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              article.content ?? 'No Content Available',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white, // Set text color to white
                fontWeight: FontWeight.normal, // Set font weight to normal
              ),
            ),
          ],
        ),
      ),
    );
  }
}
