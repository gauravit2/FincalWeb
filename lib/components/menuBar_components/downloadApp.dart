import 'package:flutter/material.dart';
import 'package:fincalweb_project/helper/size_config.dart';
import 'package:url_launcher/url_launcher.dart';

class DownloadButton extends StatelessWidget {
  final String downloadUrl;

  DownloadButton({required this.downloadUrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 1.5.w),
      child: TextButton(
        onPressed: _launchURL,
        child: Text(
          'Download Android App',
          style: TextStyle(color: Colors.white, fontSize: 1.3.t),
        ),
      ),
    );
  }

  void _launchURL() async {
    if (await canLaunch(downloadUrl)) {
      await launch(downloadUrl);
    } else {
      throw 'Could not launch $downloadUrl';
    }
  }
}
