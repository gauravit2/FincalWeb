import 'package:flutter/material.dart';
import 'package:fincalweb_project/helper/size_config.dart';

class StatItem extends StatelessWidget {
  final String value;
  final String description;
  final bool isHovering;

  const StatItem({
    Key? key,
    required this.value,
    required this.description,
    required this.isHovering,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      transform: isHovering ? Matrix4.identity().scaled(1.05) : Matrix4.identity(),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isHovering ? Colors.white : Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: isHovering
            ? [
          BoxShadow(
            color: Colors.white60,
            blurRadius: 10,
            spreadRadius: 3,
          ),
        ]
            : [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 1.5.t,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 1.3.t,
            ),
          ),
        ],
      ),
    );
  }
}
