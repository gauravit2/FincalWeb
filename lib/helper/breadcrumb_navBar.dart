import 'package:flutter/material.dart';

class BreadcrumbNavBar extends StatelessWidget {
  final List<String> breadcrumbItems;
  final List<String> routes;

  BreadcrumbNavBar({required this.breadcrumbItems, required this.routes});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: List.generate(breadcrumbItems.length, (index) {
          return GestureDetector(
            onTap: () {
              // Navigate to the corresponding route
              Navigator.pushNamed(context, routes[index]);
            },
            child: Row(
              children: [
                Text(
                  breadcrumbItems[index],
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                  ),
                ),
                if (index < breadcrumbItems.length - 1)
                  Icon(
                    Icons.chevron_right,
                    color: Colors.black,
                    size: 16,
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
