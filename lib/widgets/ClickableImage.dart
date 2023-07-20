import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ClickableImage extends StatelessWidget {
  final String imageUrl;
  final String androidUrl;
  final String iosUrl;

  ClickableImage({required this.imageUrl, required this.androidUrl, required this.iosUrl});

  void _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (Theme.of(context).platform == TargetPlatform.android) {
          _launchUrl(androidUrl);
        } else if (Theme.of(context).platform == TargetPlatform.iOS) {
          _launchUrl(iosUrl);
        }
      },
      child: Image.asset(imageUrl),
    );
  }
}
