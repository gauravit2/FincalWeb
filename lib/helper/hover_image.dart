import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fincalweb_project/helper/size_config.dart';

class HoverImage extends StatefulWidget {
  final String imageUrl;
  final double height;
  final double width;
  final double borderRadius;
  final BoxFit boxFit;

  const HoverImage({
    required this.imageUrl,
    this.height = 25.0, // Default height in percentage
    this.width = 50.0, // Default width in percentage
    this.borderRadius = 5.0,
    this.boxFit = BoxFit.cover,
  });

  @override
  _HoverImageState createState() => _HoverImageState();
}

class _HoverImageState extends State<HoverImage> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _isHovering = true;
        });
      },
      onExit: (_) {
        setState(() {
          _isHovering = false;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        transform: _isHovering ? Matrix4.identity().scaled(0.9) : Matrix4.identity(),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          boxShadow: _isHovering
              ? [BoxShadow(color: Colors.black26, blurRadius: 2, spreadRadius: 2)]
              : [],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          child: CachedNetworkImage(
            imageUrl: widget.imageUrl,
            height: widget.height.h,
            width: widget.width.w,
            fit: widget.boxFit,
            placeholder: (context, url) => Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
          ),
        ),
      ),
    );
  }
}
