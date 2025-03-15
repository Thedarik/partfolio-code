import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialButton extends StatelessWidget {
  final IconData icon;
  final String url;

  const SocialButton({
    super.key,
    required this.icon,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: FaIcon(icon),
      onPressed: () => _launchUrl(url),
      iconSize: 24,
      color: Colors.blue,
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