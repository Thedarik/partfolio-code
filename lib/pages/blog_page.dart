import 'package:flutter/material.dart';
import 'package:me_partfolio/widgets/section_title.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../viewmodels/blog_viewmodel.dart';

class BlogPage extends StatelessWidget {
  final bool isDarkMode;

  const BlogPage({super.key, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isMobile = screenSize.width < 800;

    return ChangeNotifierProvider(
      create: (_) => BlogViewModel(),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: screenSize.width > 1200 ? 1200 : double.infinity),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionTitle(title: 'Blog'),
                const SizedBox(height: 30),
                Consumer<BlogViewModel>(
                  builder: (context, viewModel, child) => _buildBlogGrid(isMobile, viewModel.blogs),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBlogGrid(bool isMobile, List blogs) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isMobile ? 1 : 3,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 1.5,
      ),
      itemCount: blogs.length,
      itemBuilder: (context, index) {
        final blog = blogs[index];
        return GestureDetector(
          onTap: () => _launchUrl(blog.link),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: isDarkMode ? const Color(0xFF252525) : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  blog.title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  blog.description,
                  style: TextStyle(
                    fontSize: 16,
                    color: isDarkMode ? Colors.white70 : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }
}
