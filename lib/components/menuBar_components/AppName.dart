import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fincalweb_project/view/HomePage.dart';
import 'package:fincalweb_project/helper/size_config.dart';

class AppNameWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      },
      child: Row(
        children: [
          ClipOval(
            child: CachedNetworkImage(
              imageUrl: 'assets/images/logo1.jpeg',
              height: 4.t,
              width: 4.t,
              fit: BoxFit.fill,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
          SizedBox(width: 2.w),
          Text(
            'Fincal',
            style: TextStyle(
              color: Colors.white,
              fontSize: 2.t,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
