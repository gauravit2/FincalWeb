import 'package:flutter/material.dart';
import 'package:fincalweb_project/helper/size_config.dart';
import 'package:fincalweb_project/components/Home_page_components/stat_item.dart';
import 'package:url_launcher/url_launcher.dart';


class StatItemContent extends StatelessWidget {
  final List<bool> isHoveringStatItems;
  final Function(int) onHover;
  final double screenWidth;

  const StatItemContent({
    Key? key,
    required this.isHoveringStatItems,
    required this.onHover,
    required this.screenWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 2.h),
          Text(
            'Financial Investments Planner',
            style: TextStyle(
              color: Colors.teal.shade700,
              fontSize: 3.t,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 1.h),
          ElevatedButton(
            onPressed: () async {
              const url = 'https://play.google.com/store/apps/details?id=com.gp.emicalculator';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal.shade800,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 4.w),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'Download App',
              style: TextStyle(fontSize: 1.t),
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Icon(Icons.star, color: Colors.amber, size: 1.5.t),
              SizedBox(width: 2.w),
              Text('4.7 Play store', style: TextStyle(fontSize: 1.5.t)),
            ],
          ),
          SizedBox(height: 1.h),
          Wrap(
            alignment: WrapAlignment.start,
            spacing: 20,
            runSpacing: 20,
            children: [
              _buildStatItem('6000+', 'Active Customers', 0),
              _buildStatItem('20000+', 'Monthly Calculations', 1),
              _buildStatItem('30000+', 'Total App Downloads', 2),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String description, int index) {
    return MouseRegion(
      onEnter: (_) => onHover(index),
      onExit: (_) => onHover(-1),
      child: StatItem(
        value: value,
        description: description,
        isHovering: isHoveringStatItems[index],
      ),
    );
  }
}
